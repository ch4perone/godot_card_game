extends CardState

func enter() -> void:
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.state.text = "Released"

