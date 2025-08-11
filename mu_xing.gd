class_name Mu_xing extends CharacterBody2D

@export var face_direction : int = 1
@export var acceleration :float= 2500.0
@export var decelration = 3200.0
@export var turning_acceleration = 360.0
@export var jump_hang_treshold = 0.1
@export var MAX_SPEED = 200.0
@export var jump_cut = 0.25
@export var gravity_max = 1020.0

@export var JUMP_VELOCITY = -500.0
@export var WALL_PUSHBACK_VELOCITY = 300.0

@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var jump_coyote_timer: Timer = $JumpCoyoteTimer
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumpping = false
var interactable_with : Array[Interactable]

func register_interactable(v: Interactable) -> void:
	if v in interactable_with:
		return
	interactable_with.append(v)

func unregister_interactable(v: Interactable) -> void:
	interactable_with.erase(v)

func get_input() -> Dictionary:
	return {
		"x": int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
		"y": int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")),
		"just_jump": Input.is_action_just_pressed("move_jump") == true,
		"jump": Input.is_action_pressed("move_jump") == true,
		"inter_act": Input.is_action_pressed("inter_act") == true
	}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"move_jump"):
		jump_buffer_timer.start()
	if event.is_action_pressed(&"interact") and interactable_with.size() > 0:
		interactable_with.back().interact()

func _physics_process(delta: float) -> void:
	x_movement(delta)
	jump_logic()
	apply_gravity(delta)
	var direction = get_input()["x"]
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	if is_on_floor():
		if direction == 0:
			animated_sprite.play(&"idle")
		else:
			animated_sprite.play(&"move")
	else:
		if velocity.y < 0:
			animated_sprite.play(&"jump")
		elif velocity.y < gravity_max * 0.1:
			animated_sprite.play(&"idle")
		else:
			animated_sprite.play(&"fall")

	move_and_slide()

func _process(_delta: float) -> void:
	$InteractionIcon.visible = !interactable_with.is_empty()

func x_movement(delta: float) -> void:
	var x_dir = get_input()["x"]
	if x_dir == 0:
		var _decelration = decelration
		if not is_on_floor():
			_decelration *= 0.2
		velocity.x = Vector2(velocity.x, 0).move_toward(Vector2(0, 0), _decelration * delta).x
		return

	if abs(velocity.x) >= MAX_SPEED and sign(velocity.x) == x_dir:
		return
	var accel_rate : float = acceleration if sign(velocity.x) == x_dir else turning_acceleration
	velocity.x += x_dir * accel_rate * delta

func jump_logic() -> void:
	if is_on_floor():
		jump_coyote_timer.start()
		is_jumpping = false
	if jump_coyote_timer.time_left > 0 and !is_jumpping and jump_buffer_timer.time_left > 0:
		is_jumpping = true
		jump_coyote_timer.stop()
		jump_buffer_timer.stop()
		velocity.y = JUMP_VELOCITY

func apply_gravity(delta: float) -> void:
	if jump_coyote_timer.time_left > 0:
		return
	if not is_on_floor():
		velocity.y += gravity * delta
	if velocity.y > gravity_max:
		velocity.y = gravity_max
