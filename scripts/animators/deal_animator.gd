extends Node
class_name DealAnimator

signal deal_finished()

# Play a deal animation. Parameters:
# - hand: Array of card data (any)
# - card_scene: PackedScene to instantiate card nodes
# - hand_anchor: Node3D where cards will be parented
# - deck_anchor: Node3D used to compute starting local position
# - spacing: float distance between cards
# - fan_angle_deg: float total fan angle in degrees
# - max_duration: float maximum duration for farthest card
# - finish_stagger: float time between subsequent card finish times
# - dist_weight: float weighting applied to translation distance when computing duration (default 0.5)
# - rot_weight: float weighting applied to rotation delta when computing duration (default 0.5)
#
# This node will add instantiated cards as children of hand_anchor. It will free itself
# shortly after the animation finishes.
func play_deal(hand: Array, card_scene: PackedScene, hand_anchor: Node3D, deck_anchor: Node3D, spacing: float, fan_angle_deg: float, max_duration: float, finish_stagger: float, dist_weight: float = 0.5, rot_weight: float = 0.5) -> void:
	var card_count = hand.size()
	if card_count == 0:
		# nothing to do; emit and queue_free
		emit_signal("deal_finished")
		queue_free()
		return

	# compute layout
	var total_width = (card_count - 1) * spacing
	var start_x = - total_width / 2.0
	var fan_angle = deg_to_rad(fan_angle_deg)
	var start_angle = - fan_angle / 2.0

	# Starting local position (deck) - compute once
	var start_local = hand_anchor.to_local(deck_anchor.global_transform.origin)

	# First: instantiate all cards and compute their target transforms.
	var card_entries: Array = []
	for i in range(card_count):
		var card_data = hand[i]
		var card = card_scene.instantiate()
		if card == null:
			push_error("card_scene.instantiate() returned null!")
			continue

		card.card_data = card_data
		hand_anchor.add_child(card)
		card.position = start_local

		# Safely get the rot pivot node from the instantiated card so we can read its starting rotation
		var rot_pivot_node = null
		if card.has_node("RotPivot"):
			rot_pivot_node = card.get_node("RotPivot")
		var start_rot_deg = 0.0
		if rot_pivot_node != null:
			start_rot_deg = rot_pivot_node.rotation_degrees.y

		# Compute target local position & rotation
		var t = float(i) / (card_count - 1) if card_count > 1 else 0.5
		var angle = start_angle + t * fan_angle
		var target_pos = Vector3(start_x + i * spacing, 0, 0)
		var target_rot_deg = rad_to_deg(-angle)

		card_entries.append({
			"index": i,
			"card": card,
			"target_pos": target_pos,
			"target_rot_deg": target_rot_deg,
			"start_rot_deg": start_rot_deg
		})

	# Compute distance from deck for each entry and rotation delta; use both to compute duration
	var max_dist = 0.0
	var max_rot = 0.0
	for e in card_entries:
		var d = e["target_pos"].distance_to(start_local)
		e["distance"] = d
		if d > max_dist:
			max_dist = d

		var rot_delta = abs(e["target_rot_deg"] - e.get("start_rot_deg", 0.0))
		e["rot_delta"] = rot_delta
		if rot_delta > max_rot:
			max_rot = rot_delta

	# Duration scaling: combine translation distance and absolute rotation delta.
	# We allow different weighting for distance vs rotation via dist_weight and rot_weight.
	var MIN_DURATION_FLOOR = 0.05
	var min_duration = min(max_duration, MIN_DURATION_FLOOR)
	# Normalize weights (fallback to equal weights if both are <= 0)
	var dist_w = dist_weight
	var rot_w = rot_weight
	var total_w = dist_w + rot_w
	if total_w <= 0.0:
		dist_w = 0.5
		rot_w = 0.5
	else:
		dist_w = dist_w / total_w
		rot_w = rot_w / total_w
	for e in card_entries:
		var frac_dist = 0.0
		if max_dist > 0.0:
			frac_dist = e["distance"] / max_dist
		var frac_rot = 0.0
		if max_rot > 0.0:
			frac_rot = e["rot_delta"] / max_rot
		var frac = frac_dist * dist_w + frac_rot * rot_w
		e["duration"] = lerp(min_duration, max_duration, frac)

	# Decide the visual order: leftmost to rightmost (target_pos.x ascending)
	card_entries.sort_custom(func(a, b):
		return sign(a["target_pos"].x - b["target_pos"].x)
	)

	# Compute finish times so that the rightmost card finishes first, then each subsequent
	# card finishes finish_stagger seconds after the previous one.
	var first_finish = card_entries[0]["duration"]
	var last_finish_time = 0.0
	var last_tween = null
	for order_idx in range(card_entries.size()):
		var entry = card_entries[order_idx]
		var card = entry["card"]
		var target_pos = entry["target_pos"]
		var target_rot_deg = entry["target_rot_deg"]
		var dur = entry["duration"]

		var desired_finish = first_finish + order_idx * finish_stagger
		var start_delay = max(0.0, desired_finish - dur)

		# Create tweens on the hand_anchor to ensure their lifetime isn't tied to this animator node
		# Otherwise when this node is freed, animation sequence will stop midway
		var tw = hand_anchor.create_tween()
		tw.tween_property(card, "position", target_pos, dur) \
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(start_delay)

		# Safely get the rot pivot node from the instantiated card (avoid depending on onready timing)
		var rot_pivot_node = null
		if card.has_node("RotPivot"):
			rot_pivot_node = card.get_node("RotPivot")

		if rot_pivot_node != null:
			tw.tween_property(rot_pivot_node, "rotation_degrees:y", target_rot_deg, dur) \
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(start_delay)
		else:
			push_warning("Card instance has no RotPivot node; skipping rotation tween")

		entry["start_delay"] = start_delay
		entry["finish_time"] = start_delay + dur
		if entry["finish_time"] > last_finish_time:
			last_finish_time = entry["finish_time"]
			last_tween = tw

	# When the last animation finishes, emit signal and free self
	if last_tween != null:
		last_tween.connect("finished", Callable(self , "_on_finished"))
	else:
		emit_signal("deal_finished")
		queue_free()

func _on_finished() -> void:
	emit_signal("deal_finished")
	queue_free()
