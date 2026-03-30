extends Sprite2D

@onready var win_text : Label = $Label

func _trophy_body_entered(body: Node2D) -> void:
	if body == Global.game_manager.player:
		win_text.visible = true