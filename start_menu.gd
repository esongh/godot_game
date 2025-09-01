extends Control
class_name StartMenu

@export var world_scene : PackedScene = preload("res://Core/world.tscn")

@onready var play_button : Button = %Play
@onready var quit_button : Button = %Quit

func _ready() -> void:
	play_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	play_button.grab_focus()

func _on_start_button_pressed() -> void:
	var world_inst : Node = world_scene.instantiate()
	get_tree().root.add_child(world_inst)
	queue_free()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
