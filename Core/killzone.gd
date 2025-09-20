extends Area2D
class_name Killzone

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body) -> void:
	var parent_node = get_parent()
	if not parent_node or not parent_node is Level:
		print("Error: Kill zone must be a child of Level")
		return
	parent_node.failed.call_deferred()
