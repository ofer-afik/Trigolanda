class_name GameManager extends Node

@export var world_2D : Node2D
@export var gui : Control

var current

func _ready() -> void:
		Global.game_manager = self
