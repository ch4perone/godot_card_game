class_name BoardUI
extends CanvasLayer

@export var stats: Stats : set = _set_stats

@onready var hand: Hand = $Hand as Hand
@onready var end_turn_button: Button = %EndTurnButton as Button

func _ready() -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	
func _set_stats(value: Stats):
	stats = value
	hand.stats = stats

func _on_player_hand_drawn() -> void:
	end_turn_button.disabled = false

func _on_end_turn_button_pressed() -> void:
	end_turn_button.disabled = true
	Events.player_turn_ended.emit()
