extends Control

var demo_2d = preload("res://assets/scenes/2d/demo_level_2d.tscn")
var audio_world_1 = preload("res://assets/scenes/Audio/audio_world_1.tscn")
var demo_ui = preload("res://assets/scenes/UI/demo_level_ui.tscn")


func _on_play_pressed() -> void:
	Global.game_manager.to_scene(demo_2d, audio_world_1, demo_ui)
