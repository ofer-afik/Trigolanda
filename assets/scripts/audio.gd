extends Node

var manager

# Audio players
@onready var bgmusic: AudioStreamPlayer2D = $BG_music
@onready var run_sfx: AudioStreamPlayer2D = $player_sfx/run_sfx

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

# Signal Connections
func _on_player_running_state_changed(is_running: bool) -> void:
	if is_running and not run_sfx.playing:
		run_sfx.play()
	elif not is_running and run_sfx.playing:
		run_sfx.stop()

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
