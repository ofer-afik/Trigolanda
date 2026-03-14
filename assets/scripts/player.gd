class_name Player extends CharacterBody2D

@export var SPEED : float = 700.0
@export var JUMP_VELOCITY : float = 900.0
@export var AIR_ACCEL : float = 0.075
@export var GROUND_ACCEL : float = 0.5

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var global = Global

# Slime trail variables
@onready var ray_cast_rt : RayCast2D = $RayCastRight
@onready var ray_cast_lt : RayCast2D = $RayCastLeft
var slime_trail = preload("res://assets/scenes/slime_trail.tscn")
var pos_last_slime_inst = 0.0
var slime_interval = 20.0

# Textures for left and right facing sprites
var look_left = load("res://assets/sprites/characters/main_char/char_sprites/char_up_lt.png")
var look_right = load("res://assets/sprites/characters/main_char/char_sprites/char_up_rt.png")

# Movement state variables
var last_grounded = 0.0
var last_jump_pressed = 0.0
var target_velocity_x = 0.
var dir = 0.0 # This way (global) we can detect from animation tree
var elapsed_since_jump_pressed = 101.0
var elapsed_since_grounded = 101.0

func _ready() -> void:
	# Set the global player reference to this instance so other scripts can access it
	await get_tree().process_frame # Wait a frame to ensure everything is initialized
	Global.game_manager.player = self

	# Set gravity physics engine variables
	Global.game_manager.gravity = Vector2(0, 980)
	up_direction = Vector2(0, -1)

	# Set slime trail position to current position so it doesn't spawn a slime at the start
	pos_last_slime_inst = global_position.x

	# Set anim_tree to active
	anim_tree.active = true


# General movement and input handling
func _physics_process(_delta: float) -> void:
	# First second of the game, allow player to look around before gravity or input is applied.
	if Time.get_ticks_msec() < 2000:
		return
	
	# ---------- Handle input ----------
	# Jump input
	if Input.is_action_just_pressed("jump"):
		last_jump_pressed = Time.get_ticks_msec()

	elapsed_since_jump_pressed = (Time.get_ticks_msec()) - last_jump_pressed

	# Horizontal movement input
	dir = Input.get_axis("move_left", "move_right")

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

	# Animations and sprite flipping
	if dir != 0:
		if dir < 0:
			sprite.texture = look_left
		elif dir > 0:
			sprite.texture = look_right

	# --------- Vertical Movement ---------
	# Ground detection
	if is_on_floor():
		last_grounded = Time.get_ticks_msec()

	# Jumping logic
	elapsed_since_grounded = (Time.get_ticks_msec()) - last_grounded
	if elapsed_since_grounded < 100 and elapsed_since_jump_pressed < 100:
		# Apply jump velocity
		last_jump_pressed = 2000
		var jump_velocity = -sign(Global.game_manager.gravity.y) * JUMP_VELOCITY
		velocity.y = jump_velocity

	if  Input.is_action_just_released("jump"):
		if Global.game_manager.gravity.y > 0:
			if velocity.y < 0:
				# Apply variable jump height
				velocity.y *= 0.5
		else:
			if velocity.y > 0:
				# Apply variable jump height
				velocity.y *= 0.5

	# Gravity
	velocity.y += Global.game_manager.gravity.y / 30

	velocity.y = clamp(velocity.y, -JUMP_VELOCITY, JUMP_VELOCITY)

	# ---------- Apply movement ----------
	move_and_slide()

	# ---------- Slime trail ----------
	if not (ray_cast_lt.is_colliding() and ray_cast_rt.is_colliding() and is_on_floor()):
		return

	var delta_curPos_lastInstantiate = abs(global_position.x - pos_last_slime_inst)

	if delta_curPos_lastInstantiate >= slime_interval:
		# Reset for next slime instantiation
		pos_last_slime_inst = global_position.x

		# Instantiate
		var slime = slime_trail.instantiate()
		slime.position = global_position
		get_tree().get_root().get_node("GameManager/World2D").add_child(slime)
