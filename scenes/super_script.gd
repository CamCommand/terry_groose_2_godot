@tool
extends RichTextEffect
class_name SuperscriptEffect

var bbcode = "super"

func _process_custom_fx(char_fx):
	# Offset the character's vertical position
	#var animation_speed = char_fx.env.get("animation_speed", 5)
	#var wave_span = char_fx.env.get("wave_span", 10)
	#var alpha_vaule = sin(char_fx.elapsed_time * animation_speed + wave_span)
	#char_fx.color.a = alpha_vaule
	char_fx.offset = Vector2(0, -5) # Negative value to move up
	return true
