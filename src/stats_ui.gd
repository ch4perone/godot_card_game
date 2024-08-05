class_name StatsUI
extends HBoxContainer

@onready var temperature: HBoxContainer = $Temperature
@onready var temperature_label: Label = %TemperatureLabel
@onready var fortune: HBoxContainer = $Fortune
@onready var fortune_label: Label = %FortuneLabel



func update_stats(stats: Stats) -> void:
	print("In update_stats")
	temperature_label.text = str(stats.temperature)
	temperature_label.add_theme_color_override("font_color", temperature_to_color(stats.temperature))
	fortune_label.text = str(stats.fortune)


func temperature_to_color(temperature: float) -> Color:
	var color: Color
	if temperature >= 20:
		color = Color.ORANGE.lerp(Color.RED, (temperature - 20) / 10.0)
	elif temperature >= 10:
		color = Color.YELLOW.lerp(Color.ORANGE, (temperature - 10) / 10.0)
	else:
		color = Color.BLUE.lerp(Color.YELLOW, temperature / 10.0)
	return color
