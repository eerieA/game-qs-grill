extends RuleConditionBase
class_name IsFlushCondition

@export var count: int = 5

func _init():
	type = "is_flush"

func evaluate(context: HandContext) -> Dictionary:
	for suit in context.suit_counts.keys():
		var got := int(context.suit_counts[suit])
		if got >= count:
			return {
				"matched": true,
				"data": {
					"suit": suit,
					"count": got
				}
			}

	return { "matched": false, "data": {} }
