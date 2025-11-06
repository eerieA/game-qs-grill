extends Node3D

@onready var deck = Deck.new()
@onready var evaluator = HandEvaluator.new()
@onready var hand_anchor = $HandAnchor

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
	
	# Visualize the random hand
	_display_hand(hand)

func _display_hand(hand: Array):
	var card_count = hand.size()
	if card_count == 0:
		return

	var spacing = 1.2  # distance between cards in meters
	var total_width = (card_count - 1) * spacing
	var start_x = -total_width / 2.0

	var fan_angle = deg_to_rad(20.0)  # total spread angle
	var start_angle = -fan_angle / 2.0

	for i in range(card_count):
		var card_data = hand[i]

		var card = card3d_scene.instantiate()
		if card == null:
			push_error("card3d_scene.instantiate() returned null!")
			return

		card.card_data = card_data

		# Calculate each card's rotation using total spread angle and num of cards
		var t = float(i) / (card_count - 1)
		var angle = start_angle + t * fan_angle

		card.position = Vector3(start_x + i * spacing, 0, 0)
		card.rotation_degrees.y = rad_to_deg(-angle)
		hand_anchor.add_child(card)
