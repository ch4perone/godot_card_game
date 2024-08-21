extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready

	
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
	
	card_ui.reparent_requested.emit(card_ui)
	card_ui.color.color = Color.SEA_GREEN
	card_ui.color.color.a = 0.5
	card_ui.state.text = "BASE"
	card_ui.pivot_offset = Vector2.ZERO
	#card_ui.remove_glow()
	


func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)
