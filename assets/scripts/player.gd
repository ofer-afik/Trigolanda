extends CharacterBody2D

@export var SPEED = 500.0
@export var JUMP_VELOCITY = 900.0
@export var AIR_ACCEL = 0.05
@export var GROUND_ACCEL = 0.2

@onready var animplay: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var look_left = load("res://assets/sprites/main_char/char_up_lt.png")
var look_right = load("res://assets/sprites/main_char/char_up_rt.png")

var last_grounded = 0.0
var last_jump_pressed = 0.0
var target_velocity_x = 0.0


# Animation states.
enum State {
	# Ground states.
	IDLE,
	RUNNING,

	# Air states.
	JUMP_START,
	IN_AIR,
	LANDING
}

var anim_state : State = State.IDLE
var past_anim_state : State = State.IDLE

func _physics_process(_delta: float) -> void:
	# ---------- Handle input ----------
	# Jump input
	if Input.is_action_just_pressed("jump"):
		last_jump_pressed = Time.get_ticks_msec()

	var elapsed_since_jump_pressed = (Time.get_ticks_msec()) - last_jump_pressed

	# Horizontal movement input
	var dir = Input.get_axis("move_left", "move_right")

	# --------- Horizontal Movement ---------
	# Horizontal movement logic
	var accel = GROUND_ACCEL if is_on_floor() else AIR_ACCEL
	target_velocity_x = dir * SPEED
	var velocity_delta = target_velocity_x - velocity.x

	# Calculate acceleration towards target velocity
	var velocity_x = velocity.x

	if abs(velocity_delta) > abs(accel):
		velocity_x += velocity_delta * accel
		velocity_x = clamp(velocity_x, -SPEED, SPEED)
	else:
		velocity_x = target_velocity_x

	# Apply acceleration
	velocity.x = velocity_x

	# --------- Vertical Movement ---------
	# Jumping logic
	if is_on_floor():
		last_grounded = Time.get_ticks_msec()

	var elapsed_since_grounded = (Time.get_ticks_msec()) - last_grounded
	var jump_velocity = -sign(get_gravity().y) * JUMP_VELOCITY

	if elapsed_since_grounded < 200 and elapsed_since_jump_pressed < 200:
		velocity.y = jump_velocity
		last_jump_pressed = 2000

	if  Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y += get_gravity().y / 3

	# Gravity
	velocity.y += get_gravity().y / 30

	velocity.y = clamp(velocity.y, -JUMP_VELOCITY, JUMP_VELOCITY)

	# ---------- Apply movement ----------
	move_and_slide()
