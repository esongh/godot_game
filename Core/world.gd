extends Node2D
class_name World

@export var levels : Array[PackedScene]

@onready var _pause_menu := $CanvasLayer/PauseMenu as PauseMenu
var scene_transition : PackedScene = preload("res://UIScene/scene_transition.tscn")
var failed_scene : PackedScene = preload("res://UIScene/failed_scene.tscn")
var current_level: Level
var level : int = 0
var transition_inst : Node

func _ready() -> void:
	# Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	Globals.world = self
	Globals.player = $"Mu-xing"
	Globals.camera = $"Camera2D"
	Globals.ui = $CanvasLayer
	Globals.player.visible = false
	update_level()

func _process(_delta: float) -> void:
	if Globals.player.visible and Globals.pross_camera:
		Globals.camera.position = Globals.player.position

func update_level() -> void:
	Globals.player.set_physics_process(false)
	transition_inst = scene_transition.instantiate()
	add_child(transition_inst)
	var animation_player : AnimationPlayer = transition_inst.get_node("AnimationPlayer")
	animation_player.play(&"bloc_in")
	await animation_player.animation_finished
	if current_level:
		current_level.queue_free()

	if level >= levels.size():
		back_to_menu()
		return

	var inst : Level = levels[level].instantiate()
	inst.change_scene.connect(_on_level_change_scene)

	inst.start()
	add_child(inst)
	animation_player.play(&"bloc_out")
	Globals.player.visible = true
	Globals.player.set_physics_process(true)
	current_level = inst
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

func game_over() -> void:
	Globals.player.set_physics_process(false)
	Globals.player.visible = false
	Globals.player.position = Vector2(0, 0)
	var fail_scene_inst : CanvasLayer = failed_scene.instantiate()
	Globals.ui.add_child(fail_scene_inst)
	current_level.queue_free()

func back_to_menu() -> void:
	var start_menu_scene : PackedScene = preload("res://StartMenu.tscn")
	Globals.player.queue_free()
	Globals.camera.queue_free()
	Globals.ui.queue_free()

	var start_menu_inst : Node = start_menu_scene.instantiate()
	get_tree().root.add_child(start_menu_inst)
	queue_free()
