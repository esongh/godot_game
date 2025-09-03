extends Interactable
class_name FlashBacke

@export var cut_scene : PackedScene
var cut_scene_inst : CutScene

func interact() -> void:
	if cut_scene == null:
		return
	cut_scene_inst = cut_scene.instantiate()
	cut_scene_inst.cut_scene_ended.connect(_on_cut_scene_ended)
	Globals.ui.add_child(cut_scene_inst)
	Globals.player.set_physics_process(false)

func _on_cut_scene_ended() -> void:
	cut_scene_inst.queue_free()
	Globals.player.set_physics_process(true)
