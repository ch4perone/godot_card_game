class_name Hand
extends HBoxContainer

@export var stats : Stats
@onready var card_ui := preload("res://scenes/card_ui.tscn")

var cards_played_this_turn := 0


func _ready() -> void:
	Events.card_played.connect(_on_card_played)

func add_card(card: Card):
	var new_card_ui := card_ui.instantiate()
	add_child(new_card_ui)
	new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
	new_card_ui.card = card
	new_card_ui.parent = self
	new_card_ui.stats = stats

func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.reparent(self)
	var new_index := clampi(child.original_index - cards_played_this_turn, 0, get_child_count()) 
	move_child.call_deferred(child, new_index)
	print("Reparented to hand")

func _on_card_played(_card: Card) -> void:
	cards_played_this_turn += 1
