extends Area2D

@export var bounce_force = Vector2(0, -500)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	body.velocity.y = bounce_force.y
	$AnimationPlayer.play("bounce")
