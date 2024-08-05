class_name Player
extends Node2D

@export var stats: Stats : set = set_character_stats

@onready var texture_rect : TextureRect = $TextureRect
@onready var stats_ui : StatsUI = $StatsUI

	
func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	update_player() # workaround for correct display of statsUI

func set_character_stats(value: Stats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)

	update_player()

	
func update_player() -> void:
	if not stats is Stats:
		print("stats not of type Stats (in player.gd)")
		return
	if not is_inside_tree():
		return
	
	update_stats()
	
func update_stats() -> void:
	stats_ui.update_stats(stats)
	
	
func change_fortune(value: int):
	stats.change_fortune(value)
	
	# Some queue free code in the tutorial | probably not necessary here
