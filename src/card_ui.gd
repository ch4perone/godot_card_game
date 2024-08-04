class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

@export var card: Card
@export var is_permanent: bool
@onready var type_label: Label = $TypeLabel
@onready var color: ColorRect = $ColorRect
@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine = $CardStateMachine as CardStateMachine
@onready var drop_targets: Array[Node] = []

var parent: Control
var tween: Tween

func _ready():
	card_state_machine.init(self)
	if is_permanent:
		type_label.text = "Permanent"

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _on_drop_point_detector_area_entered(area) -> void:
	if not drop_targets.has(area):
		drop_targets.append(area)


func _on_drop_point_detector_area_exited(area):
	drop_targets.erase(area)
