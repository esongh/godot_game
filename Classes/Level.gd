extends Node
class_name Level

@export var cameraLimitTop: int = -1000
@export var cameraLimitBottom: int = 1000
@export var cameraLimitLeft: int = -1000
@export var cameraLimitRight: int = 1000

@onready var killzone: Killzone = $Killzone

signal change_scene

var started: bool = false
var initialize_timer : Timer

func _ready():
	print("ready")
	killzone.position = Vector2(0, cameraLimitBottom)
	initialize_timer = Timer.new()
	initialize_timer.one_shot = true
	initialize_timer.timeout.connect(func():
		started = true
		initialize_timer.queue_free()
	)
	add_child(initialize_timer)
	initialize_timer.start(0.1)

	if Globals.player == null:
		setup_test_globals()
		start()

func start() -> void:
	Globals.player.position = $EntryPosition.position
	Globals.camera.limit_top = cameraLimitTop
	Globals.camera.limit_bottom = cameraLimitBottom
	Globals.camera.limit_left = cameraLimitLeft
	Globals.camera.limit_right = cameraLimitRight

func exit_level() -> void:
	change_scene.emit()

func setup_test_globals() -> void:
	var testPlay: PackedScene = load("res://mu_xing.tscn")
	Globals.player = testPlay.instantiate()
	Globals.player.scale = Vector2(2, 2)
	add_child(Globals.player)
	Globals.camera = Camera2D.new()
	Globals.camera.make_current()
	Globals.camera.position_smoothing_enabled = true
	Globals.camera.drag_horizontal_enabled = true
	Globals.camera.drag_vertical_enabled = true
	Globals.camera.drag_top_margin = 0.4
	Globals.camera.drag_bottom_margin = 0.4
	Globals.player.add_child(Globals.camera)

func failed() -> void:
	if not started:
		return
	Globals.world.game_over()
