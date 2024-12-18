class_name CardContainer
extends Node2D

@onready var glow_panel : Panel = $GlowPanel
@onready var background_panel : Panel = $BackgroundPanel
@onready var shader_material := ShaderMaterial.new()
@onready var container : HBoxContainer = $HBoxContainer
@onready var icon: TextureRect = $Icon

@export_category("Appearance")
@export var icon_texture: Texture2D
@export var icon_color : Color = CustomColors.apply_alpha(0.7, CustomColors.BRONZE)
@export var glow_color : Color = Color.GOLD
@export var border_color : Color = CustomColors.BRONZE
@export var size: Vector2 = Vector2(280, 490)

@export_category("Functiojns")
@export var listening_to_card_type: Card.Type

func _ready() -> void:
	glow_panel.size = size
	background_panel.size = size
	var style_box := background_panel.get_theme_stylebox("panel").duplicate()
	if style_box is StyleBoxFlat:
		style_box.border_color = border_color
		background_panel.add_theme_stylebox_override("panel", style_box)

	$HBoxContainer.size = size
	
	shader_material.shader = preload("res://scenes/styleboxes/glow.gdshader")
	glow_panel.material = shader_material
	hide_glow()
	
	if icon_texture != null:
		icon.texture = icon_texture
		icon.modulate = icon_color
		center_icon()
	

	Events.card_drag_found_target.connect(_on_card_drop_possible)
	Events.card_drag_lost_target.connect(_on_card_drop_ended)
	Events.card_drag_ended.connect(_on_card_drop_ended)

func center_icon() -> void:
	icon.position = (glow_panel.size - icon.size) / 2
	
func show_glow():
	glow_color.a = 0.5
	shader_material.set_shader_parameter("color", glow_color)
	shader_material.set_shader_parameter("glow_size", 20)
	shader_material.set_shader_parameter("rect_size", size)

func hide_glow() -> void:
	glow_color.a = 0.15
	shader_material.set_shader_parameter("color", glow_color)
	shader_material.set_shader_parameter("glow_size", 20)
	shader_material.set_shader_parameter("rect_size", size)

func _on_card_drop_possible(used_card: CardUI) -> void:
	if used_card.card.type == listening_to_card_type:
		show_glow()

func _on_card_drop_ended(used_card: CardUI) -> void:
	hide_glow()
