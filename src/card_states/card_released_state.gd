extends CardState

var played: bool

func enter() -> void:
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.state.text = "Released"

	played = false
	
	if not card_ui.drop_targets.is_empty():
		played = true
		print("Played card on targets ", card_ui.drop_targets)


func on_input(_event: InputEvent):
	if played:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
