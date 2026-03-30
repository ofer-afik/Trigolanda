class_name GameManager extends Node

# Variable for intro cutscene
var intro : Control = null

# Global variables
var gravity = Vector2(0, 980)
var player : Player
var cur_checkpoint : Node2D
var death_count = 0

# World container nodes
@onready var world_2d : Node2D = $World2D
@onready var audio : Node = $Audio
@onready var ui : Control = $UI/Control

# -------------- Scene resources --------------
# 2D world scenes
var main_menu_2d = preload("res://assets/scenes/2d/main_menu_2d.tscn")
var intro_2d = preload("res://assets/scenes/2d/intro_scene_2d.tscn")

# Audio world scenes
var audio_world_1 = preload("res://assets/scenes/Audio/audio_world_1.tscn")

# UI world scenes
var main_menu_ui = preload("res://assets/scenes/UI/main_menu_ui.tscn")
var intro_ui = preload("res://assets/scenes/UI/intro_scene_ui.tscn")

func _ready() -> void:
	Global.game_manager = self
	to_scene(intro_2d, audio_world_1, intro_ui)

# Universal functions to load levels, cutscenes, and much more
func to_scene(scene_2d, scene_audio, scene_ui):
	# Clear Scenes
	for node in world_2d.get_children():
		node.queue_free()
	
	for node in audio.get_children():
		node.queue_free()

	for node in ui.get_children():
		node.queue_free()

	# Instantiate scenes
	var new_2d = scene_2d.instantiate()
	world_2d.add_child(new_2d)

	var new_audio = scene_audio.instantiate()
	audio.add_child(new_audio)

	var new_ui = scene_ui.instantiate()
	ui.add_child(new_ui)