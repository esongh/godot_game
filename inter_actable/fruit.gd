extends Area2D
class_name Fruit

@onready var animation_player = $AnimationPlayer as AnimationPlayer

@export_enum("autumn", "winter","spring", "summer", "mangosteen") var style : String = "spring"

signal picked_up

var is_collected : bool = false

func _ready():
	var parent_node = get_parent() as PickUpManager
	if not parent_node or not parent_node is PickUpManager:
		print("Error: Fruit must be a child of PickUpManager")
		return
	parent_node.pick_ups.append(self)
	$Sprite.animation = style
	animation_player.play("float")

func _on_body_entered(_body):
	if is_collected:
		return
	is_collected = true
	animation_player.play("pickup")
	picked_up.emit(self)
	# print("item collected fruit")
	await animation_player.animation_finished
	queue_free()
