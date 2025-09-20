extends CanvasLayer

@onready var animation_player = $AnimationPlayer
@onready var retry_button = %RetryButton
@onready var exit_button = %ExitButton

func _ready() -> void:
	retry_button.pressed.connect(on_retry_pressed)
	exit_button.pressed.connect(on_exit_pressed)
	retry_button.grab_focus()
	animation_player.play(&"failed")

func on_retry_pressed() -> void:
	Globals.world.reload_level.call_deferred()
	queue_free()

func on_exit_pressed() -> void:
	Globals.world.back_to_menu.call_deferred()
	queue_free()
