extends Node

var manager

# Audio players
@onready var bgmusic: AudioStreamPlayer2D = $BGMusic
@onready var jump_sfx: AudioStreamPlayer2D = $player_sfx/jump_sfx
@onready var land_sfx: AudioStreamPlayer2D = $player_sfx/land_sfx

# Audio resources
var bg_opening = load("res://assets/sound/music/theme_track/export/theme_track_opening.wav")
var bg_loop = load("res://assets/sound/music/theme_track/export/theme_track_loop.wav")

# Audio states
var bgm_loop_state = 0 # 0: not playing, 1: playing opening, 2: playing loop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	manager = Global.game_manager


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	play_bgm()
	play_player_sfx()

# Audio functions
func play_bgm():
	if bgm_loop_state == 0:
		bgm_loop_state = 1
		bgmusic.stream = bg_opening
	elif bgm_loop_state == 1 and not bgmusic.playing:
		bgm_loop_state = 2
		bgmusic.stream = bg_loop
	if not bgmusic.playing:
		bgmusic.play()

func play_player_sfx():
	# Well, if it doesn't exist, we can't play the sound, can we?
	if Global.game_manager.player == null:
		return

	# Play sfx according to player state
	# Jump sfx
	if Global.game_manager.player.elapsed_since_jump_pressed < 100 and Global.game_manager.player.elapsed_since_grounded < 100 and not jump_sfx.playing:
		jump_sfx.play()
		return
	
	# Land sfx
	if Global.game_manager.player.anim_tree.get("parameters/playback").get_current_node() == "land":
		if not land_sfx.playing:
			land_sfx.play()
	else:
		land_sfx.stop()
