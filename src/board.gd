class_name Board
extends Node2D

@export var stats : Stats

@onready var board_ui: BoardUI = $BoardUI as BoardUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var player: Player = $Player as Player

func _ready() -> void:
	# Temporary code: Will reset stats for a new Board scene
	var new_stats: Stats = stats.create_instance()
	board_ui.stats = new_stats
	player.stats = new_stats
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(player_handler.start_turn)

	start_session(new_stats)
	
func start_session(stats: Stats) -> void:
	print("Session has started")
	player_handler.start_session(stats)
