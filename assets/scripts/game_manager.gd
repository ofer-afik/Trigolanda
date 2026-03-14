class_name GameManager extends Node

@export var world_2D : Node2D
@export var gui : Control
@export var gravity = Vector2(0, 980)

var player : Player

func _ready() -> void:
	Global.game_manager = self