class_name Game extends Node

@onready var _pause_menu := $InterfaceLayer/PauseMenu as PauseMenu

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"menu_toggle"):
		var tree := get_tree()
		if not tree.paused:
			tree.paused = true
			_pause_menu.open()
		else:
			tree.paused = false
			_pause_menu.close()
		get_tree().root.set_input_as_handled()
