extends Node3D

@onready var deck = Deck.new()
@onready var hand_anchor = $HandAnchor

@export var card3d_scene: PackedScene

# These are used to store values passed from the HSlider value change
var fan_angle_deg: float = 20.0
var card_spacing: float = 0.005  # In world units, e.g. 1.0 means 1 m

var current_hand: Array = []


func _ready():
	deck.generate_deck()
	deck.shuffle_deck()

	# current_hand = deck.draw(5)				# draw a random hand
	# current_hand = deck.draw_test_flush()	# draw a fixed test flush hand
	# current_hand = deck.draw_test_pair()	# draw a fixed test single pair hand
	# current_hand = deck.draw_test_three()	# draw a fixed test three-of-a-kind hand
	current_hand = deck.draw_test_four()	# draw a fixed test four-of-a-kind hand
	# current_hand = deck.draw_test_straight()	# draw a fixed test straight hand
	
	var context = HandContext.new(current_hand)
	print("--- Your hand ---")
	for c in current_hand:
		print("%s of %s" % [c.rank, c.suit])

	var result = RuleEvaluator.evaluate_hand(context)
	print("--- Result ---")
	print(result)

	# Visualize the random hand
	_display_hand(current_hand)


func _display_hand(hand: Array):
	var card_count = hand.size()
	if card_count == 0:
		return

	# distance between cards in meters
	var total_width = (card_count - 1) * card_spacing
	var start_x = -total_width / 2.0

	# total spread angle
	var fan_angle = deg_to_rad(fan_angle_deg)
	var start_angle = -fan_angle / 2.0

	for i in range(card_count):
		var card_data = hand[i]

		var card = card3d_scene.instantiate()
		if card == null:
			push_error("card3d_scene.instantiate() returned null!")
			return

		card.card_data = card_data
		hand_anchor.add_child(card)

		# Calculate each card's rotation using total spread angle and num of cards
		var t = float(i) / (card_count - 1)
		var angle = start_angle + t * fan_angle

		card.position = Vector3(start_x + i * card_spacing, 0, 0)
		#card.rotation_degrees.y = rad_to_deg(-angle)
		card.set_rotation_y(rad_to_deg(-angle))


func _refresh_hand():
	# Remove current hand and re-display it with new layout
	for c in hand_anchor.get_children():
		c.queue_free()
	_display_hand(current_hand)


func _on_fan_angle_slider_value_changed(value: float) -> void:
	fan_angle_deg = value
	_refresh_hand()


func _on_spacing_slider_value_changed(value: float) -> void:
	card_spacing = value
	_refresh_hand()
