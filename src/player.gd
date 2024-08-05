class_name Player
extends Node2D

@export var stats: Stats : set = set_character_stats

@onready var texture_rect : TextureRect = $TextureRect
@onready var stats_ui : StatsUI = $StatsUI

func set_character_stats(value: Stats) -> void:
	stats = value.create_instance()


