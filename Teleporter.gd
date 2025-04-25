class_name Teleporter
extends Interactable

@export_file("*.tscn") var path : String

func interact() -> void:
	get_tree().change_scene_to_file(path)
