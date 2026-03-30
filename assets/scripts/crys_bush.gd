extends Node2D

func _on_body_entered(body: Node2D) -> void:
	if body == Global.game_manager.player:
		Global.game_manager.player.die()
