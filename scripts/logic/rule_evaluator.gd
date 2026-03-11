extends Node
# Autoload this singleton (Project Settings -> AutoLoad)

var rules: Array[Rule] = []


func _ready() -> void:
	load_rules("res://rules")


func load_rules(path: String) -> void:
	rules.clear()

	var dir := DirAccess.open(path)
	if dir == null:
		push_error("Couldn't open rules dir: %s" % path)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()

	while file_name != "":
		# Skip directories
		if dir.current_is_dir():
			file_name = dir.get_next()
			continue

		var full_path := path.path_join(file_name)

		if file_name.ends_with(".tres") or file_name.ends_with(".res"):
			var r := ResourceLoader.load(full_path)
			if r is Rule:
				rules.append(r)

		file_name = dir.get_next()

	_validate_rules()
	dir.list_dir_end()

	for r in rules:
		print("[DEBUG] RULE LOADED:", r.id, ", priority=", r.priority, ", group=", r.dominance_group, ", enabled=", r.enabled, ", source=", r if r.has_method("get_path") else "resource")

	rules.sort_custom(Callable(self, "_sort_rules"))


func _sort_rules(a: Rule, b: Rule) -> bool:
	if a.priority == b.priority:
		return a.id < b.id
	return a.priority > b.priority

# ------------------------------------------------------------
# Public API
# ------------------------------------------------------------


func evaluate_hand(context: HandContext) -> Dictionary:
	var raw_matches: Array[Dictionary] = []

	# Detect all matching rules
	for r in rules:
		if not r.enabled:
			continue

		if r.condition_resource == null:
			push_error("Rule '%s' has no condition_resource" % r.id)
			continue

		var result := r.condition_resource.evaluate(context)

		if not result.get("matched", false):
			continue

		raw_matches.append({
			"rule": r,
			"info": result
		})

	for m in raw_matches:
		var rr: Rule = m["rule"]
		print("[DEBUG] MATCHED:", rr.id, ", priority=", rr.priority, ", group=", rr.dominance_group, ", info=", m["info"])

	# Resolve dominance groups
	var resolved: Array[Dictionary] = []
	var by_group := { }  # group_name -> match dict

	for m in raw_matches:
		var r: Rule = m["rule"]
		var g: String = r.dominance_group

		if g == "":
			# No dominance group → always applies
			resolved.append(m)
		else:
			# Keep only highest-priority rule per group
			if not by_group.has(g) or r.priority > by_group[g]["rule"].priority:
				by_group[g] = m

	for m in by_group.values():
		resolved.append(m)

	# Compute scores for each resolved rule
	var matches: Array[Dictionary] = []

	for m in resolved:
		var r: Rule = m["rule"]
		var info: Dictionary = m["info"]

		var base := int(info.get("base_score", r.base_score))
		var mult := float(info.get("multiplier", r.multiplier))
		var score := float(base) * mult

		matches.append({
			"rule_id": r.id,
			"rule_name": r.name,
			"group": r.dominance_group,
			"info": info,
			"score": score,
			"_base": base,
			"_mult": mult
		})

	# If there are no resolved matches, return zero total as before
	if matches.size() == 0:
		return {
			"matches": matches,
			"total": 0.0
		}

	# Determine dominant rule: highest base*mult
	var dominant_idx: int = 0
	var best_value: float = float(matches[0]["_base"]) * float(matches[0]["_mult"])
	for i in range(1, matches.size()):
		var val: float = float(matches[i]["_base"]) * float(matches[i]["_mult"])
		if val > best_value:
			best_value = val
			dominant_idx = i

	var dominant = matches[dominant_idx]
	var dominant_rule: Rule = null
	# Find the original rule object for the dominant match
	for m in resolved:
		if m["rule"].id == dominant["rule_id"]:
			dominant_rule = m["rule"]
			break

	# Collect valid cards according to the dominant rule's condition
	var valid_cards: Array = _collect_valid_cards_for_condition(dominant_rule.condition_resource, dominant["info"], context)

	# Sum card values and compute final score, currently value is exaclt equal to numerical rank
	var card_sum := 0
	for c in valid_cards:
		card_sum += int(c.rank)

	var final_total := float(card_sum + int(dominant["_base"])) * float(dominant["_mult"])

	# For convenience include dominant info and the valid cards summary in the result
	var valid_card_summaries := []
	for c in valid_cards:
		valid_card_summaries.append({"rank": c.rank, "suit": c.suit})

	return {
		"matches": matches,
		"dominant_rule_id": dominant["rule_id"],
		"dominant_rule_name": dominant["rule_name"],
		"valid_cards": valid_card_summaries,
		"total": final_total
	}

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------


func _validate_rules() -> void:
	for r in rules:
		r.validate()


# Returns an Array of CardData objects from the context.hand that are considered
# "valid" for the given condition and its evaluation info.
func _collect_valid_cards_for_condition(cond: RuleConditionBase, info: Dictionary, context: HandContext) -> Array:
	if cond == null:
		return []

	var result: Array = []
	var hand: Array = context.hand

	match cond.type:
		"count_rank":
			var needed: int = int(cond.count)
			var ranks_to_include: Array = []
			if cond.rank >= 0:
				if int(context.rank_counts.get(cond.rank, 0)) >= needed:
					ranks_to_include.append(cond.rank)
			else:
				for rk in context.rank_counts.keys():
					if int(context.rank_counts[rk]) >= needed:
						ranks_to_include.append(rk)

			for c in hand:
				if c.rank in ranks_to_include:
					result.append(c)

		"exact_count_rank":
			var needed_e: int = int(cond.count)
			var ranks_e: Array = []
			if cond.rank >= 0:
				if int(context.rank_counts.get(cond.rank, 0)) == needed_e:
					ranks_e.append(cond.rank)
			else:
				for rk in context.rank_counts.keys():
					if int(context.rank_counts[rk]) == needed_e:
						ranks_e.append(rk)

			for c in hand:
				if c.rank in ranks_e:
					result.append(c)

		"is_flush":
			# Prefer data-provided suit if present
			var suit: Variant = info.get("data", {}).get("suit", null)
			if suit == null:
				# find suits with enough cards according to cond.count
				for s in context.suit_counts.keys():
					if int(context.suit_counts[s]) >= int(cond.count):
						suit = s

			if suit != null:
				for c in hand:
					if c.suit == suit:
						result.append(c)

		"sequence":
			# Compute the best consecutive run of ranks and include cards whose rank is in that run
			# Build unique sorted ranks
			var unique_ranks: Array = []
			var seen: Dictionary = {}
			for r in context.ranks:
				if not seen.has(r):
					unique_ranks.append(r)
					seen[r] = true

			if unique_ranks.size() == 0:
				return []

			var best_start: int = 0
			var best_len: int = 1
			var cur_start: int = 0
			var cur_len: int = 1

			for i in range(1, unique_ranks.size()):
				if unique_ranks[i] == unique_ranks[i - 1] + 1:
					cur_len += 1
				else:
					# end run
					if cur_len > best_len or (cur_len == best_len and unique_ranks[i - 1] > unique_ranks[best_start + best_len - 1]):
						best_start = cur_start
						best_len = cur_len
					cur_start = i
					cur_len = 1

			# final run check
			if cur_len > best_len or (cur_len == best_len and unique_ranks[unique_ranks.size() - 1] > unique_ranks[best_start + best_len - 1]):
				best_start = cur_start
				best_len = cur_len

			var run_ranks: Array = unique_ranks.slice(best_start, best_start + best_len)
			for c in hand:
				if c.rank in run_ranks:
					result.append(c)

		"and":
			# Intersection of child condition valid sets
			if not cond.conditions or cond.conditions.size() == 0:
				return []
			var sets: Array = []
			for child in cond.conditions:
				var child_info: Dictionary = child.evaluate(context)
				if child_info.get("matched", false):
					sets.append(_collect_valid_cards_for_condition(child, child_info, context))

			if sets.size() == 0:
				return []
			# intersect by rank+suit key
			var intersect: Array = sets[0]
			for i in range(1, sets.size()):
				var next: Array = sets[i]
				var tmp: Array = []
				for c in intersect:
					for d in next:
						if c.rank == d.rank and c.suit == d.suit:
							tmp.append(c)
				intersect = tmp
			result = intersect

		"or":
			# Use the first matching child condition (consistent with OrCondition.evaluate)
			for child in cond.conditions:
				var child_res: Dictionary = child.evaluate(context)
				if child_res.get("matched", false):
					result = _collect_valid_cards_for_condition(child, child_res, context)
					break

		_:
			# Fallback: try to use info.data hints
			var data: Dictionary = {}
			if info.has("data") and typeof(info["data"]) == TYPE_DICTIONARY:
				data = info["data"]
			if data.has("rank"):
				for c in hand:
					if c.rank == int(data["rank"]):
						result.append(c)
			elif data.has("suit"):
				for c in hand:
					if c.suit == data["suit"]:
						result.append(c)

	return result
