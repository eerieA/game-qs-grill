extends RuleConditionBase
class_name AndCondition

@export var conditions: Array[RuleConditionBase] = []


func _init():
    type = "and"


func evaluate(context: HandContext) -> Dictionary:
    if conditions.is_empty():
        # Vacuously true
        return { "matched": true, "data": { } }

    var combined_data := { }

    for cond in conditions:
        if cond == null:
            push_error("AndCondition contains a null condition")
            return { "matched": false, "data": { } }

        var res := cond.evaluate(context)
        if not res.get("matched", false):
            return { "matched": false, "data": { } }

        # Merge child data for debugging / UI
        if res.has("data"):
            combined_data.merge(res["data"], true)

    return {
        "matched": true,
        "data": combined_data
    }
