class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL := 0.25
const HAND_DISCARD_INTERVAL := 0.25


@export var hand: Hand

var stats: Stats

func _ready() -> void:
	Events.card_played.connect(_on_card_played)

func _input(_event):
	if Input.is_action_pressed("quit_game"):
		get_tree().quit()
	if Input.is_action_pressed("draw_card"):
		draw_cards(1)

func start_session(starting_stats: Stats) -> void:
	stats = starting_stats
	stats.draw_pile = stats.deck.duplicate(true)
	stats.draw_pile.shuffle()
	stats.discard_pile = CardPile.new()
	start_turn()

func start_turn() -> void:
	draw_cards(stats.cards_per_turn)
	
func end_turn() -> void:
	hand.disable_hand()
	discard_cards()
	
func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(stats.draw_pile.draw_card())
	reshuffle_deck_from_discard()

func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)
	
	tween.finished.connect(
		func (): Events.player_hand_drawn.emit()
	)

func discard_cards() -> void:
	
	# Temporary: Nothing happens on empty hand
	if hand.get_child_count() == 0:
		Events.player_hand_discarded.emit()
		return
		
	var tween := create_tween()
	for card_ui in hand.get_children():
		tween.tween_callback(stats.discard_pile.add_card.bind(card_ui.card))
		tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERVAL)
	
	tween.finished.connect(
		func (): Events.player_hand_discarded.emit()
	)

func reshuffle_deck_from_discard() -> void:
	if not stats.draw_pile.empty():
		return
		
	while not stats.discard_pile.empty():
		stats.draw_pile.add_card(stats.discard_pile.draw_card())
	
	stats.draw_pile.shuffle()
	
func _on_card_played(card: Card) -> void:
	if card.is_instant():
		stats.discard_pile.add_card(card)
