class_name Board
extends Node2D

@export var stats : Stats

@onready var board_ui: BoardUI = $BoardUI as BoardUI

func _ready() -> void:
	# Temporary code: Will reset stats for a new Board scene
	var new_stats: Stats = stats.create_instance()
	board_ui.stats = new_stats
	
	start_session(new_stats)
	
func start_session(stats: Stats) -> void:
	print("Session has started")
