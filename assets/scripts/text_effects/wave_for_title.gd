@tool
extends RichTextEffect
class_name WaveForTitle

var bbcode : String = "titlewave"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var amp = char_fx.env["amp"]
	var freq = char_fx.env["freq"]
	var speed = char_fx.env["speed"]

	char_fx.offset.y = sin(speed * char_fx.elapsed_time + char_fx.range.x * freq) * amp
	
	return true
