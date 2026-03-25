@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name EmpasisText
extends RichTextEffect

var bbcode := "emph"


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.color = Color(1, 0, 0, 1)
	char_fx.offset.y = sin(char_fx.relative_index * 10 + char_fx.elapsed_time * 50)
	char_fx.offset.x = cos(char_fx.elapsed_time * 100 + char_fx.relative_index)

	return true