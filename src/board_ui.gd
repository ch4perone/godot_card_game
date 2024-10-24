class_name BoardUI
extends CanvasLayer

@export var stats: Stats : set = _set_stats

@onready var hand: Hand = $Hand as Hand


func _set_stats(value: Stats):
	stats = value
	hand.stats = stats
