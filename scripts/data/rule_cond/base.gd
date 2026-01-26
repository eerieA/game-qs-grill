extends Resource
class_name RuleConditionBase

@export var type: String

func evaluate(context: HandContext) -> Dictionary:
	push_error("evaluate() not implemented for RuleConditionBase")
	return { "matched": false, "data": {} }

func validate() -> void:
	pass
