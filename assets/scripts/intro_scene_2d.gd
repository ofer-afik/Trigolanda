extends Node2D

var text_boxes : Array[TextBox] = []
var scenes : Array[Node2D] = []

var cur_box : int = 0
var cur_scene : int = 0

func _ready() -> void:
	while Global.game_manager.intro == null:
		await get_tree().process_frame
	fill_boxes_and_scenes()
	for box in text_boxes:
		box.visible = false
	for scene in scenes:
		scene.visible = false
	text_boxes[0].visible = true
	scenes[0].visible = true

func _input(event: InputEvent) -> void:
	if Global.game_manager.intro == null or !event.is_action_pressed("jump"):
		return
	
	text_boxes[cur_box].visible = false
	scenes[cur_scene].visible = false
	cur_box += 1
	cur_scene += 1
	if cur_box < text_boxes.size() and cur_scene < text_boxes.size():
		text_boxes[cur_box].visible = true
		scenes[cur_scene].visible = true
	else:
		for box in text_boxes:
			box.visible = false
		for scene in scenes:
			scene.visible = false
		text_boxes[0].visible = true
		scenes[0].visible = true
		Global.game_manager.to_scene()
	
func _exit_tree() -> void:
	Global.game_manager.intro = null

func fill_boxes_and_scenes():
	while Global.game_manager.intro == null:
		await get_tree().process_frame

	for child in Global.game_manager.intro.get_children():
		text_boxes.append(child)

	for child in $Scenes.get_children():
		scenes.append(child)
