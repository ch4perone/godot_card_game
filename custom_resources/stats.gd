class_name Stats
extends Resource

signal stats_changed

@export var starting_deck : CardPile
@export var cards_per_turn := 3
@export var starting_fortune := 0
@export var starting_temperature := 15.0
@export var starting_humidity := 50.0
@export var starting_orchard := 0

#@export var soil_humindity := 0.5

var fortune : int : set = set_fortune
var temperature : float : set = set_temperature
var humidity : float : set = set_humidity
var orchard : int : set = set_orchard
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

func set_humidity(value: float) -> void:
	humidity = value
	stats_changed.emit()

func set_orchard(value: int) -> void:
	orchard = value
	stats_changed.emit()


func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard_pile = CardPile.new()
	
	instance.fortune = starting_fortune
	instance.temperature = starting_temperature
	instance.humidity = starting_humidity
	instance.orchard = starting_orchard
	return instance
	
func can_play_card(card: Card):
	return card.value + self.fortune >= 0
