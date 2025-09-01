extends Node
class_name Level

@export var caremaLimitTop: int = -1000
@export var caremaLimitBottom: int = 1000
@export var caremaLimitLeft: int = -1000
@export var caremaLimitRight: int = 1000

@onready var killzone: Killzone = $Killzone

signal change_scene

func _ready():
	killzone.position = Vector2(0, caremaLimitBottom)
	if Globals.player == null:
		setup_test_globals()
		start()

func start() -> void:
	Globals.player.position = $EntryPosition.position
	Globals.camera.limit_top = caremaLimitTop
	Globals.camera.limit_bottom = caremaLimitBottom
	Globals.camera.limit_left = caremaLimitLeft
	Globals.camera.limit_right = caremaLimitRight

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
	Globals.player.add_child(Globals.carmera)
