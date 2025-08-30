class_name PauseMenu extends Control

@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont := $ColorRect/CenterContainer as CenterContainer
@onready var resume_button := $ColorRect/CenterContainer/VBoxContainer/ResumeButton as Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func close() -> void:
	var tween := create_tween()
	get_tree().paused = false
	tween.tween_property(
		self, ^"modulate:a", 0.0, fade_out_duration
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(
		center_cont, ^"anchor_bottom", 0.5, fade_out_duration
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	print("closing")
	tween.tween_callback(self.hide).set_delay(fade_out_duration)

func open() -> void:
	show()
	resume_button.grab_focus()
	modulate.a = 0.0
	center_cont.anchor_bottom = 0.5
	var tween := create_tween()
	tween.tween_property(
		self, ^"modulate:a", 1.0, fade_in_duration
		).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(
		self, ^"anchor_bottom", 1.0, fade_in_duration
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_resume_button_pressed() -> void:
	close()

func _on_quit_button_pressed() -> void:
	if visible:
		get_tree().quit()

func _on_reload_pressed() -> void:
	if visible:
		await Globals.world.reload_level()
		close()
