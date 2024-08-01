extends CardState


func enter() -> void:
	card_ui.color.color = Color.ORANGE
	card_ui.state.text = "Clicked"
	card_ui.drop_point_detector.monitoring = true
	
