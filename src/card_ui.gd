class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

const GLOW_FAINT_STYLE_BOX := preload("res://scenes/skyboxes/card_glow_faint_stylebox.tres")
const GLOW_STYLE_BOX := preload("res://scenes/skyboxes/card_glow_stylebox.tres")
const GLOW_STRONG_STYLE_BOX := preload("res://scenes/skyboxes/card_glow_strong_stylebox.tres")


@export var card: Card : set = _set_card
@export var stats: Stats

@onready var type_label: Label = $TypeLabel
@onready var color: ColorRect = $ColorRect
@onready var value_label = $Value

# Artsy stuff
@onready var card_art: Sprite2D = $CardArt
@onready var glow_panel = $GlowPanel
@onready var border_panel = $BorderPanel
var is_glowing_strong := false

@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine = $CardStateMachine as CardStateMachine
@onready var drop_targets: Array[Node] = []
@export var base_shimmer_material: ShaderMaterial
@export var base_glow_material: ShaderMaterial

var shimmer_material: ShaderMaterial
var shimmer_enabled := false
var shimmer_time := 0.0
var parent: Control
var tween: Tween

func _ready():
	card_state_machine.init(self)
	shimmer_material = base_shimmer_material.duplicate()
	if shimmer_material:
		shimmer_material.set_shader_parameter("time", 0.0)
		shimmer_material.set_shader_parameter("shine_color", Color(1, 1, 1, 0.5))
		shimmer_material.set_shader_parameter("shine_speed", 4)
		shimmer_material.set_shader_parameter("shine_size", 0.01)
		card_art.material = shimmer_material
	
	remove_shimmer()
	remove_glow()

func play() -> void:
	if not card:
		return
	card.play(drop_targets, stats)
	
	if not card.is_permanent:
		queue_free() # TODO add to discard pile

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	type_label.text = card.id
	if FileAccess.file_exists(card.texture_path):
		card_art.texture = load(card.texture_path)
		card_art.scale = size / card_art.texture.get_size()
	value_label.text = str(card.value)
	if card.is_permanent:
		type_label.text += "\nPermanent"
	else:
		type_label.text +="\nInstant"
	
func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	add_shimmer()
	if not is_glowing_strong:
		add_glow()


func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	remove_shimmer()
	if not is_glowing_strong:
		remove_glow()

func _on_drop_point_detector_area_entered(area) -> void:
	if area.is_in_group("card_drop_area"): 
		print("Collision with card drop area")
		if not drop_targets.has(area):
			drop_targets.append(area)
			if card_state_machine.current_state.state == CardState.State.DRAGGING:
				add_strong_glow()
	elif area.is_in_group("card_target_selector"):
		print("Collision with card targeting system")
		if not is_glowing_strong:
			add_glow()
		
func _on_drop_point_detector_area_exited(area):
	drop_targets.erase(area)
	if area.is_in_group("card_drop_area") and is_glowing_strong:
		is_glowing_strong = false
		add_glow()
	elif area.is_in_group("card_target_selector"):
		if not is_glowing_strong:
			remove_glow()

func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)
	
func add_shimmer():
	shimmer_enabled = true
	if shimmer_material:
		shimmer_material.set_shader_parameter("time", 0.0)
	card_art.material = shimmer_material

func remove_shimmer():
	card_art.material = null
	shimmer_enabled = false
	if shimmer_material:
		shimmer_material.set_shader_parameter("time", 0.0)

func add_strong_glow():
	is_glowing_strong = true
	glow_panel.add_theme_stylebox_override("panel", GLOW_STRONG_STYLE_BOX)

func add_glow():
	glow_panel.visible = true
	glow_panel.add_theme_stylebox_override("panel", GLOW_STYLE_BOX)

func remove_glow():
	# Alternatively, make glow invisible
	glow_panel.add_theme_stylebox_override("panel", GLOW_FAINT_STYLE_BOX)
	
	
func _process(delta):
	if shimmer_enabled and shimmer_material:
		shimmer_time += delta
		shimmer_material.set_shader_parameter("time", shimmer_time)
	elif shimmer_material:
		shimmer_material.set_shader_parameter("time", 0.0)
