extends Node
class_name Deck

const SUITS = ["hearts", "diamonds", "clubs", "spades"]
const RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]  # 11=J, 12=Q, 13=K, 14=A

var cards: Array[CardData] = []


func _ready():
	generate_deck()
	shuffle_deck()


func generate_deck():
	cards.clear()
	for suit in SUITS:
		for rank in RANKS:
			var c = CardData.new()
			c.suit = suit
			c.rank = rank
			cards.append(c)


func shuffle_deck():
	cards.shuffle()


func draw(n: int) -> Array[CardData]:
	var drawn: Array[CardData] = []
	for i in range(n):
		if cards.is_empty():
			break
		drawn.append(cards.pop_back())
	return drawn
