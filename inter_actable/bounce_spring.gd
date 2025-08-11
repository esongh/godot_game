extends Area2D

@export var bounce_force = Vector2(0, -700)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.name == "Mu-xing":
		body.velocity.y = bounce_force.y
		body.velocity.x = bounce_force.x
		$AnimationPlayer.play("bounce")
