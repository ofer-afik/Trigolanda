extends Sprite2D

var sprites : Array[Texture2D] = [
	preload("res://assets/sprites/characters/main_char/trail_sprites/trail_1.svg"),
	preload("res://assets/sprites/characters/main_char/trail_sprites/trail_2.svg"),
	preload("res://assets/sprites/characters/main_char/trail_sprites/trail_3.svg"),
	preload("res://assets/sprites/characters/main_char/trail_sprites/trail_4.svg"),
	preload("res://assets/sprites/characters/main_char/trail_sprites/trail_5.svg"),
	preload("res://assets/sprites/characters/main_char/trail_sprites/trail_6.svg"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = sprites.pick_random()

func _on_timer_timeout() -> void:
	queue_free()