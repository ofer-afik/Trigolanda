extends Control

@onready var death_count : RichTextLabel = $Label

func _process(_delta: float) -> void:
	death_count.text = "[emph]Deaths: " + str(Global.game_manager.death_count)
