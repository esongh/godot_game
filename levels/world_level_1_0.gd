extends Level

@onready var dialog_file = preload("res://dialog/ui_dialogues.tscn")
var loc_inst : Dialogues

@onready var memory_scene = preload("res://UIScene/cut_scene_1.tscn")

const Balloon = preload("res://dialog/balloon.tscn")
@export var dialogue_resource : DialogueResource
@export var dialogue_start : String = "start"
var cut_scene_inst : Node

func _on_area_2d_body_entered(body: Node2D) -> void:
	if cut_scene_inst != null:
		return
	print("dialog start")
	cut_scene_inst = memory_scene.instantiate()
	cut_scene_inst.cut_scene_ended.connect(on_cut_scene_ended)
	Globals.ui.add_child(cut_scene_inst)
	# var loc_inst : Node = Balloon.instantiate()
	#Globals.ui.add_child(loc_inst)
	# loc_inst.start(dialogue_resource, dialogue_start)

func on_cut_scene_ended() -> void:
	Globals.ui.remove_child(cut_scene_inst)
