class_name Teleporter
extends Interactable

func interact() -> void:
	get_parent().change_scene.emit()
