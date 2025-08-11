extends Node
class_name Level

signal  change_scene

func start() -> void:
	Globals.player.position = $EntryPosition.position

func exit_level() -> void:
	change_scene.emit()
