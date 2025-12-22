extends Resource
class_name CardData

@export var suit: String
@export var rank: int

# ----------------------
# Factory functions
# ----------------------

static func make(rank_value, suit_value: String) -> CardData:
	var c := CardData.new()
	c.suit = suit_value
	c.rank = _normalize_rank(rank_value)
	return c

static func _normalize_rank(r) -> int:
	match r:
		"A": return 14
		"K": return 13
		"Q": return 12
		"J": return 11
		_: return int(r)

# ----------------------
# Helpers
# ----------------------


func rank_as_string() -> String:
	match rank:
		14: return "A"
		13: return "K"
		12: return "Q"
		11: return "J"
		_: return str(rank)
