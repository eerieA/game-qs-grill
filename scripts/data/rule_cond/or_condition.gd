extends RuleConditionBase
class_name OrCondition

@export var conditions: Array[RuleConditionBase] = []


func _init():
    type = "or"


func evaluate(context: HandContext) -> Dictionary:
    if conditions.is_empty():
        return { "matched": false, "data": { } }

    for cond in conditions:
        if cond == null:
            push_error("OrCondition contains a null condition")
            continue

        var res := cond.evaluate(context)
        if res.get("matched", false):
            return {
                "matched": true,
                "data": res.get("data", { })
            }

    return { "matched": false, "data": { } }
