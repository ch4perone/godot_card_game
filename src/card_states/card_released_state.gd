extends CardState

var played: bool

func enter() -> void:
	card_ui.color.color = Color.DARK_VIOLET
	card_ui.color.color.a = 0.5
	card_ui.state.text = "RELEASE"
	
	played = false
	
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
	
	if not card_ui.drop_targets.is_empty():
		played = true
		print("Played card on targets ", card_ui.drop_targets)
		
		if card_ui.is_permanent:
			var ui_layer = get_tree().get_nodes_in_group("ui_layer")[1] # Permant Box
			if ui_layer:
				print("Reparented to ui_layer: ", ui_layer)
				card_ui.reparent(ui_layer)
		
		card_ui.remove_glow()

func on_input(_event: InputEvent):
	if played:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
