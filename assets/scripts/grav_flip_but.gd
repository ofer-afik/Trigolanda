extends Area2D

@onready var glow : PointLight2D = $PointLight2D

var can_flip : bool = true

var norm_col : Color = Color(0.75, 0, 1, 1)
var cooldown_col : Color = Color(0, 0.75, 1, 1)

var norm_energy : float = 500.0
var cooldown_energy : float = 2

func _ready() -> void:
	glow.color = norm_col
	glow.energy = norm_energy

func _on_body_entered(body: Node2D) -> void:
	if body == Global.game_manager.player and can_flip:
		# Cooldown setup
		can_flip = false
		glow.color = cooldown_col
		glow.energy = cooldown_energy

		# Small delay before flip
		await get_tree().create_timer(0.05).timeout
		Global.game_manager.player.velocity.y = 0
		Global.game_manager.gravity = -Global.game_manager.gravity
		Global.game_manager.player.up_direction = -Global.game_manager.player.up_direction

		# Reset crystal
		await get_tree().create_timer(2).timeout
		glow.color = norm_col
		glow.energy = norm_energy
		can_flip = true