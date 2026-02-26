extends CharacterBody2D

@onready var animplay: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var friction = 5.0

var look_left = load("res://assets/sprites/main_char/char_up_lt.png")
var look_right = load("res://assets/sprites/main_char/char_up_rt.png")

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

# Called from jump_start animation.
func jump():
	velocity.y = jump_velocity

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		anim_state = State.IN_AIR

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (anim_state == State.IDLE or anim_state == State.RUNNING) and is_on_floor():
		anim_state = State.JUMP_START

	# Handle horizontal movement.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if anim_state != State.JUMP_START:
			velocity.x = direction * speed
		else:
			velocity.x = 0
		if anim_state == State.IDLE:
			anim_state = State.RUNNING
		if direction < 0:
			sprite.texture = look_left
		else:
			sprite.texture = look_right
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * friction)
		if anim_state == State.RUNNING:
			anim_state = State.IDLE
	
	# Handle landing.
	if is_on_floor() and anim_state == State.IN_AIR:
		anim_state = State.LANDING
	
	# Handle animations.
	match anim_state:
		State.IDLE:
			if not animplay.current_animation == "idle":
				animplay.play("idle")
		State.RUNNING:
			if not animplay.current_animation == "run":
				animplay.play("run")
		State.JUMP_START:
			if not animplay.current_animation == "jump_start":
				animplay.play("jump_start")
		State.IN_AIR:
			pass
		State.LANDING:
			if not animplay.current_animation == "land":
				animplay.play("land")
	
	move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "jump_start" and anim_state == State.JUMP_START:
		anim_state = State.IN_AIR
	elif anim_name == "land" and anim_state == State.LANDING:
		anim_state = State.IDLE