class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.25

@export var hand: Hand

var stats: Stats

func start_session(starting_stats: Stats) -> void:
	stats = starting_stats
	stats.draw_pile = stats.deck.duplicate(true)
	stats.draw_pile.shuffle()
	stats.discard_pile = CardPile.new()
	start_turn()

func start_turn() -> void:
	draw_cards(stats.cards_per_turn)
	
func draw_card() -> void:
	hand.add_card(stats.draw_pile.draw_card())

func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(
		func (): Events.player_hand_drawn.emit()
	)
