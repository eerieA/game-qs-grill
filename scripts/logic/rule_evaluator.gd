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

		elif file_name.ends_with(".json"):
			if FileAccess.file_exists(full_path):
				var file := FileAccess.open(full_path, FileAccess.READ)
				if file == null:
					push_error("Couldn't open rule file: %s" % full_path)
				else:
					var parsed: Variant = JSON.parse_string(file.get_as_text())
					if parsed is Dictionary:
						rules.append(_rule_from_dict(parsed, file_name.get_basename()))
					else:
						push_error("Invalid JSON rule: %s" % full_path)
				file.close()

		file_name = dir.get_next()

	dir.list_dir_end()

	for r in rules:
		print("[DEBUG] RULE LOADED:", r.id, ", priority=", r.priority, ", group=", r.dominance_group, ", enabled=", r.enabled, ", source=", r if r.has_method("get_path") else "resource")

	rules.sort_custom(Callable(self, "_sort_rules"))


func _rule_from_dict(data: Dictionary, fallback_id: String) -> Rule:
	var r := Rule.new()
	r.id = data.get("id", fallback_id)
	r.name = data.get("name", r.id)
	r.description = data.get("description", "")
	r.enabled = bool(data.get("enabled", true))
	r.priority = int(data.get("priority", 0))
	r.base_score = int(data.get("base_score", 0))
	r.multiplier = float(data.get("multiplier", 1.0))
	r.condition = data.get("condition", { })
	r.dominance_group = str(data.get("dominance_group", ""))
	r.tags.clear()
	for t in data.get("tags", []):
		r.tags.append(str(t))
	return r


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

		var result: Dictionary

		if r.condition_resource != null:
			# New typed condition path
			result = r.condition_resource.evaluate(context)
		else:
			# Legacy dictionary path
			result = _evaluate_condition(r.condition, context)

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

	# Compute scores
	var total := 0.0
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
			"score": score
		})

		total += score

	return {
		"matches": matches,
		"total": total
	}

# ------------------------------------------------------------
# Condition evaluator
# ------------------------------------------------------------


func _evaluate_condition(cond: Dictionary, context: HandContext) -> Dictionary:
	if typeof(cond) != TYPE_DICTIONARY:
		push_error("_evaluate_condition expects Dictionary, got %s" % typeof(cond))
		return { "matched": false, "data": { } }

	if cond.is_empty():
		return { "matched": true, "data": { } }

	var t: String = str(cond.get("type", "")).to_lower()

	match t:
		"and":
			var operands: Array[Dictionary] = cond.get("operands", [])
			if operands.is_empty():
				return { "matched": true, "data": { } }
			for sub in operands:
				var res = _evaluate_condition(sub, context)
				if not res.get("matched", false):
					return { "matched": false, "data": { } }
			return { "matched": true, "data": { } }

		"or":
			var operands: Array[Dictionary] = cond.get("operands", [])
			if operands.is_empty():
				return { "matched": false, "data": { } }
			for sub in operands:
				var res = _evaluate_condition(sub, context)
				if res.get("matched", false):
					return { "matched": true, "data": { } }
			return { "matched": false, "data": { } }

		"not":
			var operand: Dictionary = cond.get("operand", { })
			var res = _evaluate_condition(operand, context)
			return { "matched": not res.get("matched", false), "data": { } }

		"count_rank":
			var need: int = int(cond.get("count", 1))

			# If a rank key is present, interpret it as "count occurrences of this rank"
			if cond.has("rank"):
				var rank_spec = cond.get("rank")
				# allow rank to be a string like "A" or an int; convert to int if possible
				var rank_value: int = -1
				if typeof(rank_spec) == TYPE_STRING:
					# attempt to map face ranks if use them elsewhere; otherwise try to int()
					rank_value = _rank_to_value(rank_spec)
				else:
					rank_value = int(rank_spec)

				var cnt_for_rank: int = context.rank_counts.get(rank_value, 0)
				return {
					"matched": cnt_for_rank >= need,
					"data": { "rank": rank_value, "count": cnt_for_rank }
				}

			# No rank specified -> "is there any rank that appears >= need times?"
			for rk in context.rank_counts.keys():
				var got := int(context.rank_counts[rk])
				if got >= need:
					return {
						"matched": true,
						"data": { "rank": rk, "count": got }
					}
			return { "matched": false, "data": { "count": 0 } }

		"is_flush":
			var need: int = int(cond.get("count", context.hand.size()))
			for suit in context.suit_counts.keys():
				if context.suit_counts[suit] >= need:
					return { "matched": true, "data": { "suit": suit, "count": context.suit_counts[suit] } }
			return { "matched": false, "data": { } }

		"sequence":
			var length: int = int(cond.get("length", context.hand.size()))
			# Remove duplicates from sorted ranks
			var unique_ranks: Array[int] = []
			var seen: Dictionary[int, bool] = { }
			for r in context.ranks:
				if not seen.has(r):
					unique_ranks.append(r)
					seen[r] = true

			var best_run: int = 1
			var current: int = 1
			for i in range(1, unique_ranks.size()):
				if unique_ranks[i] == unique_ranks[i - 1] + 1:
					current += 1
					best_run = max(best_run, current)
				else:
					current = 1

			return { "matched": best_run >= length, "data": { "run_length": best_run } }

		_:
			var method_name := "_custom_" + t
			if has_method(method_name):
				var res = call(method_name, cond, context)
				if typeof(res) != TYPE_DICTIONARY or not res.has("matched"):
					push_error("Custom condition '%s' must return Dictionary with 'matched' key" % t)
					return { "matched": false, "data": { } }
				if not res.has("data"):
					res["data"] = { }
				return res

			push_error("Unknown condition type: %s" % t)
			return { "matched": false, "data": { } }

# ------------------------------------------------------------
# Helpers
# ------------------------------------------------------------


func _rank_to_value(rank) -> int:
	var map := {
		"A": 14,
		"K": 13,
		"Q": 12,
		"J": 11
	}

	if map.has(rank):
		return map[rank]

	return int(rank)
