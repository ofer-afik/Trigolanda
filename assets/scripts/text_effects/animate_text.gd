@tool
extends RichTextEffect
class_name AnimateText

var bbcode : String = "anim"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var speed = 30.0
	var duration = 5.0

	if char_fx.relative_index < char_fx.elapsed_time * speed:
		char_fx.visible = true
	else:
		char_fx.visible = false

	if char_fx.relative_index < char_fx.elapsed_time * speed - duration:
		return true

	var progress = (char_fx.elapsed_time * speed - char_fx.relative_index) / duration
	progress = clamp(progress, 0.0, 1.0)

	var angle = progress * PI
	char_fx.offset.y = -sin(angle) * 20

	return true
