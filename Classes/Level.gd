extends Node
class_name Level

@export var caremaLimitTop: int = -1000
@export var caremaLimitBottom: int = 1000
@export var caremaLimitLeft: int = -1000
@export var caremaLimitRight: int = 1000

signal change_scene

func _ready():
	if Globals.player == null:
		setup_test_globals()
		start()

func start() -> void:
	Globals.player.position = $EntryPosition.position
	Globals.carmera.limit_top = caremaLimitTop
	Globals.carmera.limit_bottom = caremaLimitBottom
	Globals.carmera.limit_left = caremaLimitLeft
	Globals.carmera.limit_right = caremaLimitRight

func exit_level() -> void:
	change_scene.emit()

func setup_test_globals() -> void:
	var testPlay: PackedScene = load("res://mu_xing.tscn")
	Globals.player = testPlay.instantiate()
	Globals.player.scale = Vector2(2, 2)
	add_child(Globals.player)
	Globals.carmera = Camera2D.new()
	Globals.carmera.make_current()
	Globals.carmera.position_smoothing_enabled = true
	Globals.carmera.drag_horizontal_enabled = true
	Globals.carmera.drag_vertical_enabled = true
	Globals.carmera.drag_top_margin = 0.4
	Globals.carmera.drag_bottom_margin = 0.4
	Globals.player.add_child(Globals.carmera)
