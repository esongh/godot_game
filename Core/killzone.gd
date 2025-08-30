extends Area2D
class_name Killzone

var timer : Node

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body) -> void:
	Globals.world.game_over.call_deferred()
