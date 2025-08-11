extends AnimatedSprite2D

const STICK_DEADZONE := 0.3
const MOUSE_DEADZONE := 16

func _ready() -> void:
	if Input.get_connected_joypads():
		play(&"xbox_controller")
	else:
		play(&"keyboard")

func _input(event: InputEvent) -> void:
	if (
		event is InputEventJoypadButton or
		(event is InputEventJoypadMotion and abs(event.axis_value) > STICK_DEADZONE)
	):
		play(&"xbox_controller")

	if (
		event is InputEventKey or
		event is InputEventMouseButton or
		(event is InputEventMouseMotion and event.velocity.length() > MOUSE_DEADZONE)
	):
		play(&"keyboard")
