class_name Mu_xing extends CharacterBody2D

enum State {
	Idle,
	Move,
	Jump,
	Fall
}

const GROUND_STATES := [
	State.Idle,
	State.Move
]

@export var face_direction : int = 1
@export var acceleration :float= 2500.0
@export var decelration = 3200.0
@export var turning_acceleration = 360.0
@export var jump_hang_treshold = 0.1
@export var max_speed = 200.0
@export var jump_cut = 0.25
@export var gravity_max = 1020.0

@export var SPEED: float = 200.0
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
		"released_jump": Input.is_action_just_released("move_jump") == true,
		"inter_act": Input.is_action_pressed("inter_act") == true
	}

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"move_jump"):
		jump_buffer_timer.start()
	if event.is_action_pressed(&"interact") and interactable_with != null:
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
			animated_sprite.play("idle")
		else:
			animated_sprite.play("move")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")

	move_and_slide()

func _process(_delta: float) -> void:
	$InteractionIcon.visible = !interactable_with.is_empty()

func x_movement(delta: float) -> void:
	var x_dir = get_input()["x"]
	if x_dir == 0:
		velocity.x = Vector2(velocity.x, 0).move_toward(Vector2(0, 0), decelration * delta).x
		return

	if abs(velocity.x) >= max_speed and sign(velocity.x) == x_dir:
		return
	var accel_rate : float = acceleration if sign(velocity.x) == x_dir else turning_acceleration
	velocity.x += x_dir * accel_rate * delta

func jump_logic() -> void:
	if is_on_floor():
		jump_coyote_timer.start()
		is_jumpping = false
	if get_input()["just_jump"]:
		jump_buffer_timer.start()
	if jump_coyote_timer.time_left > 0 and get_input()["jump"] and !is_jumpping:
		is_jumpping = true
		jump_coyote_timer.stop()
		jump_buffer_timer.stop()
		velocity.y = JUMP_VELOCITY
	if get_input()["released_jump"] and velocity.y < 0:
		velocity.y -= (jump_cut * velocity.y)

func apply_gravity(delta: float) -> void:
	if jump_coyote_timer.time_left > 0:
		return
	if not is_on_floor():
		velocity.y += gravity * delta

func transition_state(from : State, to : State) -> void:
	if from != State.Idle and from != State.Move:
		if to == State.Jump or to == State.Fall:
			jump_coyote_timer.stop()
	match to:
		State.Idle:
			animated_sprite.play("idle")
		State.Move:
			animated_sprite.play("move")
		State.Jump:
			animated_sprite.play("jump")
		State.Fall:
			animated_sprite.play("fall")

func get_next_state(state: State) -> int:
	var can_jump := is_on_floor() or jump_coyote_timer.time_left > 0
	var should_jump := can_jump and jump_buffer_timer.time_left > 0
	if should_jump:
		return State.Jump
	if state in GROUND_STATES and not is_on_floor():
		return State.Fall	
	
	var movement := Input.get_axis("move_left", "move_right")
	var is_still := is_zero_approx(movement) and is_zero_approx(velocity.x)

	match state:
		State.Idle:
			if not is_still:
				return State.Move
		State.Move:
			if is_still:
				return State.Idle
		State.Jump:
			if velocity.y >= 0:
				return State.Fall
		State.Fall:
			if is_on_floor():
				return State.Idle
	return StateMachine.KEEP_CURRENT
