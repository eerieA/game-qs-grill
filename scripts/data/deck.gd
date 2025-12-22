extends Node
class_name Deck

const SUITS = ["♥", "♦", "♣", "♠"]
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


func draw_test_flush() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suit := "♠"  # fixed suit for flush test
	var ranks := [2, 5, 7, 9, 9]

	for r in ranks:
		var c := CardData.new()
		c.suit = suit
		c.rank = r
		drawn.append(c)

	return drawn


func draw_test_pair() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suits := ["♥", "♦", "♣", "♠", "♠"]
	var ranks := [7, 5, 7, 9, 13]

	for i in range(5):
		var c := CardData.new()
		c.suit = suits[i]
		c.rank = ranks[i]
		drawn.append(c)

	return drawn


func draw_test_three() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suits := ["♥", "♦", "♣", "♠", "♠"]
	var ranks := [6, 5, 6, 6, 13]

	for i in range(5):
		var c := CardData.new()
		c.suit = suits[i]
		c.rank = ranks[i]
		drawn.append(c)

	return drawn


func draw_test_four() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suits := ["♥", "♦", "♣", "♠", "♠"]
	var ranks := [6, 5, 6, 6, 6]

	for i in range(5):
		var c := CardData.new()
		c.suit = suits[i]
		c.rank = ranks[i]
		drawn.append(c)

	return drawn


func draw_test_straight() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suits := ["♥", "♦", "♣", "♠", "♠"]
	var ranks := [4, 7, 6, 5, 8]

	for i in range(5):
		var c := CardData.new()
		c.suit = suits[i]
		c.rank = ranks[i]
		drawn.append(c)

	return drawn
