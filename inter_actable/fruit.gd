extends Area2D

@onready var animation_player = $AnimationPlayer as AnimationPlayer

func _on_body_entered(_body):
	animation_player.play("pickup")
	print("item collected fruit")
