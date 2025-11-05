extends Node3D

@onready var deck = Deck.new()
@onready var evaluator = HandEvaluator.new()

@export var card3d_scene: PackedScene


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

	var suits = ["♠", "♥", "♦", "♣"]
	var ranks = [10, 11, 12, 13, 1]

	for i in range(5):
		var card_data = CardData.new()
		card_data.suit = suits[i % 4]
		card_data.rank = ranks[i]

		var card = card3d_scene.instantiate()
		if card == null:
			push_error("card3d_scene.instantiate() returned null!")
			return

		card.card_data = card_data
		# Temporarily just place them with a hardcoded spacing
		card.position = Vector3(i * 1.2, 0, 0)
		add_child(card)
