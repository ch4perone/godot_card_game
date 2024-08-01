class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)


@onready var color: ColorRect = $ColorRect
@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine = $CardStateMachine as CardStateMachine



func _ready():
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
		card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
