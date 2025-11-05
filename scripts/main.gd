extends Node3D

@onready var deck = Deck.new()
@onready var evaluator = HandEvaluator.new()


func _ready():
	deck.generate_deck()
	deck.shuffle_deck()

	var hand = deck.draw(5)
	print("--- Your hand ---")
	for c in hand:
		print("%s of %s" % [c.rank, c.suit])

	var result = evaluator.evaluate_hand(hand)
	print("--- Result ---")
	print(result)
