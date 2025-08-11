extends Node2D
class_name World

@export var levels : Array[PackedScene]

@onready var _pause_menu := $CanvasLayer/PauseMenu as PauseMenu
var scene_transition : PackedScene = preload("res://UIScene/scene_transition.tscn")
var current_level: Level
var level : int = 0
var transition_inst : Node

func _ready() -> void:
	Globals.world = self
	Globals.player = $"Mu-xing"
	Globals.carmera = $"Mu-xing/Camera2D"
	Globals.ui = $CanvasLayer
	update_level.call_deferred()

func update_level() -> void:
	if level == 0:
		Globals.player.visible = false
	transition_inst = scene_transition.instantiate()
	add_child(transition_inst)
	var animation_player : AnimationPlayer = transition_inst.get_node("AnimationPlayer")
	animation_player.play(&"bloc_in")
	await animation_player.animation_finished
	Globals.player.visible = false
	if current_level:
		current_level.queue_free()
	if level >= levels.size():
		get_tree().quit()
		transition_inst.queue_free()
		return

	animation_player.play(&"bloc_out")
	Globals.player.visible = true
	var inst : Level = levels[level].instantiate()
	inst.start()
	inst.change_scene.connect(_on_level_change_scene)
	current_level = inst
	add_child(inst)
	await animation_player.animation_finished
	transition_inst.queue_free()

func _on_level_change_scene() -> void:
	level += 1
	update_level.call_deferred()

func reload_level() -> void:
	update_level()

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
