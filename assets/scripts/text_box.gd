@tool

extends NinePatchRect
class_name TextBox

@onready var label : RichTextLabel = $RichTextLabel

@export var text : String = "This is a textbox!":
	set(value):
		text = value
		if is_node_ready() and label:
			label.text = "[anim]" + value

func _ready() -> void:
	label.text = "[anim]" + text