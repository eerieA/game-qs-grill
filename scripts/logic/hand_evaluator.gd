# scripts/logic/hand_evaluator.gd
extends Node
class_name HandEvaluator


# Returns dictionary like {"name": "Pair", "chips": 10, "mult": 2}
func evaluate_hand(cards: Array[CardData]) -> Dictionary:
	if cards.size() != 5:
		return { "name": "Invalid Hand", "chips": 0, "mult": 0 }

	var ranks = cards.map(func(c): return c.rank)
	var suits = cards.map(func(c): return c.suit)

	ranks.sort()

	var is_flush = suits.all(func(s): return s == suits[0])
	var is_straight = _is_consecutive(ranks)

	var counts = { }
	for r in ranks:
		counts[r] = counts.get(r, 0) + 1
	var count_values = counts.values()
	count_values.sort()

	# Start matching patterns (from strongest to weakest)
	if is_straight and is_flush:
		return { "name": "Straight Flush", "chips": 100, "mult": 4 }
	elif 4 in count_values:
		return { "name": "Four of a Kind", "chips": 60, "mult": 3 }
	elif 3 in count_values and 2 in count_values:
		return { "name": "Full House", "chips": 50, "mult": 3 }
	elif is_flush:
		return { "name": "Flush", "chips": 40, "mult": 2 }
	elif is_straight:
		return { "name": "Straight", "chips": 30, "mult": 2 }
	elif 3 in count_values:
		return { "name": "Three of a Kind", "chips": 20, "mult": 2 }
	elif count_values.count(2) == 2:
		return { "name": "Two Pair", "chips": 15, "mult": 1.5 }
	elif 2 in count_values:
		return { "name": "Pair", "chips": 10, "mult": 1.2 }
	else:
		return { "name": "High Card", "chips": 5, "mult": 1.0 }


func _is_consecutive(arr: Array) -> bool:
	if arr.size() < 2:
		return true
	for i in range(1, arr.size()):
		if typeof(arr[i]) != TYPE_INT or typeof(arr[i - 1]) != TYPE_INT:
			push_warning("Non-int element found in _is_consecutive()")
			return false
		if arr[i] != arr[i - 1] + 1:
			return false
	return true
