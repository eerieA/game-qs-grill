extends Node3D
class_name Card3D

@export var card_data: CardData

@onready var mesh = $MeshInstance3D
@onready var label = $Label3D


func _ready():
	if card_data:
		update_visual()


func update_visual():
	if not card_data:
		return
	label.text = "%s%s" % [card_data.rank, card_data.suit]
