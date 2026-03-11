extends Node3D

@export var card_play_scene: PackedScene = preload("res://scenes/card_play_mode.tscn")

func _ready() -> void:
	# If the CardPlayMode scene was not instanced in the .tscn, instantiate it now.
	if not has_node("CardPlayMode"):
		var mode = card_play_scene.instantiate()
		add_child(mode)
