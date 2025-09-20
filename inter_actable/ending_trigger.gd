extends Area2D

@export var end_scene : PackedScene
@export var camera_position : Vector2
var scene_inst : CutScene
var scene_timer : Timer

func _on_body_entered(_body: Node2D) -> void:
	Globals.pross_camera = false
	var tween = get_tree().create_tween()
	tween.tween_property(Globals.camera, "position", camera_position, 1.2)
	Globals.player.set_physics_process(false)
	scene_timer = Timer.new()
	scene_timer.timeout.connect(_on_time_out)
	add_child(scene_timer)
	scene_timer.start(2)

func _on_time_out() -> void:
	Globals.pross_camera = true
	scene_timer.queue_free()
	if end_scene == null:
		return
	scene_inst = end_scene.instantiate()
	scene_inst.cut_scene_ended.connect(_on_cut_scene_ended)
	Globals.ui.add_child(scene_inst)

func _on_cut_scene_ended() -> void:
	scene_inst.queue_free()
	Globals.player.set_physics_process(true)
	Globals.world.back_to_menu()
