class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

@export var card: Card
@export var is_permanent: bool
@onready var type_label: Label = $TypeLabel
@onready var color: ColorRect = $ColorRect
@onready var card_art: Sprite2D = $CardArt
@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine = $CardStateMachine as CardStateMachine
@onready var drop_targets: Array[Node] = []

var parent: Control
var tween: Tween

func _ready():
	card_state_machine.init(self)
	type_label.text = card.id
	if is_permanent:
		type_label.text += "\nPermanent"
	else:
		type_label.text +="\nInstant"
	
	if FileAccess.file_exists(card.texture_path):
		card_art.texture = load(card.texture_path)
		card_art.scale = size / card_art.texture.get_size()
	
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


func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)
	
