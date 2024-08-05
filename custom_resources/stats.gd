class_name Stats
extends Resource

signal stats_changed

@export var starting_deck : CardPile
@export var cards_per_turn := 3
#@export var soil_humindity := 0.5

var fortune : int : set = set_fortune
var temperature : float : set = set_temperature
var deck: CardPile
var draw_pile: CardPile
var discard_pile: CardPile

func set_fortune(value: int) -> void:
	fortune = value
	stats_changed.emit()

func change_fortune(value: int):
	self.fortune += value
	
func set_temperature(value: float) -> void:
	temperature = value
	stats_changed.emit()

func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard_pile = CardPile.new()
	
	instance.fortune = 0
	instance.temperature = 15 
	return instance
	
func can_play_card(card: Card):
	return card.value + self.fortune >= 0
