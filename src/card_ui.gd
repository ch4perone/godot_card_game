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
@export var base_shimmer_material: ShaderMaterial

var shimmer_material: ShaderMaterial
var shimmer_enabled := false
var shimmer_time := 0.0
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
	
	shimmer_material = base_shimmer_material.duplicate()
	if shimmer_material:
		shimmer_material.set_shader_parameter("time", 0.0)
		shimmer_material.set_shader_parameter("shine_color", Color(1, 1, 1, 0.5))
		shimmer_material.set_shader_parameter("shine_speed", 2.0)
		card_art.material = shimmer_material
	
	remove_shimmer()
	
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	add_shimmer()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	remove_shimmer()

func _on_drop_point_detector_area_entered(area) -> void:
	if area.is_in_group("card_drop_area"): 
		print("Collision with card drop area")
		if not drop_targets.has(area):
			drop_targets.append(area)
	elif area.is_in_group("card_target_selector"):
		print("Collision with card targeting system")
		
func _on_drop_point_detector_area_exited(area):
	drop_targets.erase(area)


func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)
	
func add_shimmer():
	shimmer_enabled = true
	if shimmer_material:
		shimmer_material.set_shader_parameter("time", 0.0)

func remove_shimmer():
	shimmer_enabled = false
	if shimmer_material:
		shimmer_material.set_shader_parameter("time", 0.0)

func _process(delta):
	if shimmer_enabled and shimmer_material:
		shimmer_time += delta
		shimmer_material.set_shader_parameter("time", shimmer_time)
	elif shimmer_material:
		shimmer_material.set_shader_parameter("time", 0.0)
