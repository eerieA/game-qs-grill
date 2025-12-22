extends Node3D
class_name Card3D

@export var card_data: CardData

@onready var rot_pivot = $RotPivot
@onready var mesh = $RotPivot/MeshInstance3D
@onready var label = $RotPivot/Label3D


func _ready():
	if card_data:
		update_visual()


func update_visual():
	if not card_data:
		return
	label.text = "%s%s" % [card_data.rank_as_string(), card_data.suit]


# Public helper to rotate the card around an alt pivot
func set_rotation_y(angle: float):
	# print("Children of Card3D:", get_child_count(), get_child(0).name)
	rot_pivot.rotation_degrees.y = angle
