class_name StatsUI
extends HBoxContainer

@onready var temperature: HBoxContainer = $Temperature
@onready var temperature_label: Label = %TemperatureLabel
@onready var fortune: HBoxContainer = $Fortune
@onready var fortune_label: Label = %FortuneLabel
@onready var humidity: HBoxContainer = $Humidity
@onready var humidity_label: Label = %HumidityLabel
@onready var orchard: HBoxContainer = $Orchard
@onready var orchard_label: Label = %OrchardLabel


func update_stats(stats: Stats) -> void:
	print("In update_stats")
	temperature_label.text = str(stats.temperature)
	temperature_label.add_theme_color_override("font_color", temperature_to_color(stats.temperature))
	fortune_label.text = str(stats.fortune)
	humidity_label.text = str(stats.humidity)
	humidity_label.add_theme_color_override("font_color", humidity_to_color(stats.humidity))
	orchard_label.text = str(stats.orchard)


func temperature_to_color(temp: float) -> Color:
	var color: Color
	if temp >= 20:
		color = Color.ORANGE.lerp(Color.RED, (temp - 20) / 10.0)
	elif temp >= 10:
		color = Color.YELLOW.lerp(Color.ORANGE, (temp - 10) / 10.0)
	else:
		color = Color.BLUE.lerp(Color.YELLOW, temp / 10.0)
	return color

func humidity_to_color(value: float) -> Color:
	var color := Color.POWDER_BLUE.lerp(Color.ROYAL_BLUE, value / 100.0)
	return color
