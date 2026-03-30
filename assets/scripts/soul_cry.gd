extends Area2D

@onready var glow : PointLight2D = $PointLight2D

func _ready() -> void:
    glow.energy = 0

func _process(_delta: float) -> void:
    glow.energy = 500 if Global.game_manager.cur_checkpoint == get_parent() else 0

func _on_body_entered(body: Node2D) -> void:
    if body == Global.game_manager.player:
        Global.game_manager.cur_checkpoint = get_parent()