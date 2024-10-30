class_name CustomColors
extends Object


# Define custom colors as static constants
const BRONZE: Color = Color(0.69, 0.553, 0.341)
const GLOW_WEATHER: Color = Color.GOLD
const GLOW_DEFAULT: Color = Color(0, 0.553, 863, 1)
const GLOW_CURSED: Color = Color(0.6, 0.2, 0.9) 


static func apply_alpha(a: float, color: Color) -> Color:
	var col = color
	col.a = a
	return col
