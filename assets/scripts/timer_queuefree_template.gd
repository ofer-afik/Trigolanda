extends Node2D

func _input(event):
	if event.is_action_pressed("jump"):
		queue_free()
