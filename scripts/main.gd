extends Node3D

@export var card3d_scene: PackedScene
@export var card_draw_count: int = 5
@export var deal_duration: float = 0.64
@export var deal_stagger: float = 0.08 # Should be smaller than deal_duration

@onready var deck = $Deck # logic node with deck.gd
@onready var deck_anchor = $Deck/DeckAnchor # Node3D used for visuals
@onready var hand_anchor = $HandAnchor

# Preload the DealAnimator script so we don't rely on class_name registration order
const DealAnimator = preload("res://scripts/deal_animator.gd")

# These are used to store values passed from the HSlider value change
var fan_angle_deg: float = 20.0
var card_spacing: float = 0.5 # In world units, e.g. 1.0 means 1 m

var current_hand: Array = []


func _ready():
	# Deck._ready() already generates/shuffles; just draw from scene Deck.
	draw_hand()


func draw_hand():
	# remove old things if any
	for c in hand_anchor.get_children():
		c.queue_free()

	# draw from the Deck node in the scene
	current_hand = deck.draw(card_draw_count)
	_evaluate_and_log(current_hand)
	_deal_cards(current_hand)


func _evaluate_and_log(hand: Array):
	var context = HandContext.new(hand)
	print("--- Your hand ---")
	for c in hand:
		print("%s of %s" % [c.rank, c.suit])
	var result = RuleEvaluator.evaluate_hand(context)
	print("--- Result ---")
	print(result)


func _deal_cards(hand: Array):
	# Use DealAnimator to perform the animated dealing
	var animator = DealAnimator.new()
	add_child(animator)
	animator.connect("deal_finished", Callable(animator, "queue_free"))
	animator.play_deal(hand, card3d_scene, hand_anchor, deck_anchor, card_spacing, fan_angle_deg, deal_duration, deal_stagger)


func _display_hand(hand: Array):
	var card_count = hand.size()
	if card_count == 0:
		return

	# distance between cards in meters
	var total_width = (card_count - 1) * card_spacing
	var start_x = - total_width / 2.0

	# total spread angle
	var fan_angle = deg_to_rad(fan_angle_deg)
	var start_angle = - fan_angle / 2.0

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
