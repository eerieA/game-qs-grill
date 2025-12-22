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
# Helpers
# ------------------------------------------------------------


func _validate_rules() -> void:
	for r in rules:
		if r.condition_resource == null:
			push_error("Rule '%s' is missing a condition_resource" % r.id)
