extends Resource
class_name Rule

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""

@export var enabled: bool = true
@export var priority: int = 0
@export var dominance_group: String = ""

@export var base_score: int = 0
@export var multiplier: float = 1.0

# Condition data (e.g. {"hand": "flush", "min_rank": 10})
@export var condition_resource: RuleConditionBase

# Tags for rule grouping / querying
@export var tags: Array[String] = []


func validate() -> void:
    if condition_resource == null:
        push_error("Rule '%s' has no condition_resource" % id)
    else:
        condition_resource.validate()
