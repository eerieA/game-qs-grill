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
	# optional: reserve for a little speed
	cards.resize(0)
	for suit in SUITS:
		for rank in RANKS:
			# Use the factory so rank normalization happens in one place
			var c := CardData.make(rank, suit)
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

# ----------------------
# Test hand helpers (use the factory)
# ----------------------


func draw_test_flush() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suit := "♠"  # fixed suit for flush test
	var ranks := [2, 5, 7, 9, 13]  # distinct ranks preferred

	for r in ranks:
		drawn.append(CardData.make(r, suit))

	return drawn


func draw_test_pair() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suits := ["♥", "♦", "♣", "♠", "♠"]
	var ranks := [7, 5, 7, 9, "A"]

	for i in range(5):
		drawn.append(CardData.make(ranks[i], suits[i]))

	return drawn


func draw_test_three() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suits := ["♥", "♦", "♣", "♠", "♠"]
	var ranks := [6, 5, 6, 6, 13]

	for i in range(5):
		drawn.append(CardData.make(ranks[i], suits[i]))

	return drawn


func draw_test_four() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suits := ["♥", "♦", "♣", "♠", "♠"]
	var ranks := [6, 5, 6, 6, 6]

	for i in range(5):
		drawn.append(CardData.make(ranks[i], suits[i]))

	return drawn


func draw_test_straight() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suits := ["♥", "♦", "♣", "♠", "♠"]
	var ranks := [4, 7, 6, 5, 8]

	for i in range(5):
		drawn.append(CardData.make(ranks[i], suits[i]))

	return drawn


func draw_test_straight_flush() -> Array[CardData]:
	var drawn: Array[CardData] = []
	var suits := ["♥", "♥", "♥", "♥", "♥"]
	var ranks := [4, 7, 6, 5, 8]

	for i in range(5):
		drawn.append(CardData.make(ranks[i], suits[i]))

	return drawn
