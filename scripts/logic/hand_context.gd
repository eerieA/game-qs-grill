extends Resource
class_name HandContext

@export var hand: Array[CardData] = []

# Precomputed properties
var ranks: Array[int] = []
var suits: Array[String] = []
var rank_counts: Dictionary[int, int] = {}
var suit_counts: Dictionary[String, int] = {}
var is_flush: bool = false
var is_straight: bool = false

func _init(cards: Array[CardData] = []):
    hand = cards.duplicate()
    _compute_properties()

func _compute_properties():
    ranks.clear()
    suits.clear()
    rank_counts.clear()
    suit_counts.clear()

    for c in hand:
        ranks.append(c.rank)
        suits.append(c.suit)
        rank_counts[c.rank] = rank_counts.get(c.rank, 0) + 1
        suit_counts[c.suit] = suit_counts.get(c.suit, 0) + 1

    ranks.sort()
    is_flush = suits.size() > 0 and suits.all(func(s): return s == suits[0])
    is_straight = _is_consecutive(ranks)

func _is_consecutive(arr: Array[int]) -> bool:
    if arr.size() < 2:
        return true
    for i in range(1, arr.size()):
        if arr[i] != arr[i - 1] + 1:
            return false
    return true
