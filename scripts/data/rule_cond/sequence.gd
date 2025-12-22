extends RuleConditionBase
class_name SequenceCondition

@export var length: int = 5  # how many consecutive ranks required


func _init():
    type = "sequence"


func evaluate(context: HandContext) -> Dictionary:
    # Need at least `length` unique ranks
    if context.ranks.size() < length:
        return { "matched": false, "data": { } }

    # Remove duplicates while preserving order (ranks already sorted in HandContext)
    var unique_ranks: Array[int] = []
    var seen := { }

    for r in context.ranks:
        if not seen.has(r):
            unique_ranks.append(r)
            seen[r] = true

    if unique_ranks.size() < length:
        return { "matched": false, "data": { } }

    var best_run := 1
    var current := 1

    for i in range(1, unique_ranks.size()):
        if unique_ranks[i] == unique_ranks[i - 1] + 1:
            current += 1
            best_run = max(best_run, current)
        else:
            current = 1

    return {
        "matched": best_run >= length,
        "data": {
            "run_length": best_run
        }
    }
