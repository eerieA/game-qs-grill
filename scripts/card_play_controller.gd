# GDScript scripts/card_play_controller.gd
extends Node3D

@export var card3d_scene: PackedScene
@export var card_draw_count: int = 5
@export var deal_duration: float = 0.26
@export var deal_stagger: float = 0.08

# visual layout control
var fan_angle_deg: float = 20.0
var card_spacing: float = 0.5

var current_hand: Array = []

# nodes (assumes Deck node exists as child with DeckAnchor under it)
@onready var deck = $Deck
@onready var deck_anchor = $Deck/DeckAnchor
@onready var hand_anchor = $HandAnchor

# Preload DealAnimator script to avoid load-order issues
const DealAnimator = preload("res://scripts/animators/deal_animator.gd")

func _ready() -> void:
	# Deck._ready() should already prepare deck, so just draw
	draw_hand()


func draw_hand() -> void:
	# remove old things if any
	for c in hand_anchor.get_children():
		c.queue_free()

	# draw from the Deck node in the scene
	if deck == null:
		push_error("Deck node not found. Ensure CardPlayMode has a child node named 'Deck' with deck.gd attached.")
		return

	current_hand = deck.draw(card_draw_count)
	_evaluate_and_log(current_hand)
	_deal_cards(current_hand)


func _evaluate_and_log(hand: Array) -> void:
	var context = HandContext.new(hand)
	print("--- Your hand ---")
	for c in hand:
		print("%s of %s" % [c.rank, c.suit])
	var result = RuleEvaluator.evaluate_hand(context)
	print("--- Result ---")
	print(result)


func _deal_cards(hand: Array) -> void:
	var animator = DealAnimator.new()
	# Add animator to this node so it lives long enough for hand_anchor tweens to run.
	add_child(animator)
	# animator will queue_free itself after finishing, DealAnimator already emits deal_finished and frees.
	animator.play_deal(hand, card3d_scene, hand_anchor, deck_anchor, card_spacing, fan_angle_deg, deal_duration, deal_stagger, 0.7, 0.3)


func _display_hand(hand: Array) -> void:
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
		var t = float(i) / (card_count - 1) if card_count > 1 else 0.5
		var angle = start_angle + t * fan_angle

		card.position = Vector3(start_x + i * card_spacing, 0, 0)
		card.set_rotation_y(rad_to_deg(-angle))


func _refresh_hand() -> void:
	# Remove current hand and re-display it with new layout
	for c in hand_anchor.get_children():
		c.queue_free()
	_display_hand(current_hand)
