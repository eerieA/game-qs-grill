extends RuleConditionBase
class_name CountRankCondition

@export var count: int = 2
@export var rank: int = -1  # -1 = any

func _init():
	type = "count_rank"

func evaluate(context: HandContext) -> Dictionary:
	if rank >= 0:
		var got: int = int(context.rank_counts.get(rank, 0))
		return {
			"matched": got >= count,
			"data": { "rank": rank, "count": got }
		}

	for rk in context.rank_counts.keys():
		var got_any: int = int(context.rank_counts[rk])
		if got_any >= count:
			return {
				"matched": true,
				"data": { "rank": rk, "count": got_any }
			}

	return { "matched": false, "data": {} }
