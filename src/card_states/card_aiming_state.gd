extends CardState

const MOUSE_Y_SNAPBACK_THRESHOLD := 1250

func enter() -> void:
	card_ui.color.color = Color.BISQUE
	card_ui.color.color.a = 0.5
	card_ui.state.text = "AIMING"
	card_ui.drop_targets.clear()
	
	# var offset := Vector2(card_ui.parent.size.x / 2, - (card_ui.size.y / 2) - 100)
	var offset := Vector2(card_ui.parent.size.x / 2 + 400, - (card_ui.size.y / 2) - 160)
	offset.x -= card_ui.size.x / 2
	card_ui.animate_to_position(card_ui.parent.global_position + offset, 0.4)
	card_ui.drop_point_detector.monitoring = false
	Events.card_aim_started.emit(card_ui)
	
	card_ui.add_strong_glow()
	
func exit() -> void:
	Events.card_aim_ended.emit(card_ui)
	if card_ui.is_glowing_strong:
		card_ui.is_glowing_strong = false
		card_ui.remove_glow()
	
func on_input(event: InputEvent):
	var mouse_motion := event as InputEventMouseMotion
	var mouse_at_bottom := card_ui.get_global_mouse_position().y > MOUSE_Y_SNAPBACK_THRESHOLD
	
	if (mouse_motion and mouse_at_bottom) or event.is_action_pressed("right_mouse"):
		print("Transition from AIM to BASE")
		transition_requested.emit(self, CardState.State.BASE)
	elif event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse"):
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED) 
