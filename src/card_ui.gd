class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

@export var card: Card : set = _set_card
@export var stats: Stats : set = _set_stats

@export var glow_color := CustomColors.GLOW_DEFAULT

@onready var type_label: Label = $TypeLabel
@onready var color: ColorRect = $ColorRect
@onready var value_label = $Value

# Artsy stuff
@onready var card_art: Sprite2D = $CardArt
@onready var glow_panel = $GlowPanel
@onready var icon_glow_panel = %IconGlowPanel
@onready var shader_material := ShaderMaterial.new()
@onready var border_panel = $BorderPanel
@onready var icon : TextureRect = %Icon
@onready var icon_color = CustomColors.apply_alpha(0.85, CustomColors.BRONZE)
var is_glowing_strong := false

@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine = $CardStateMachine as CardStateMachine
@onready var drop_targets: Array[Node] = []
@export var base_shimmer_material: ShaderMaterial
@export var base_glow_material: ShaderMaterial
@onready var original_index := self.get_index()
@onready var weather_icon: Texture2D = preload("res://assets/icons/cloud_sun_rain_white.png")
@onready var moon_icon: Texture2D = preload("res://assets/icons/moon_white.png")
@onready var flash_icon: Texture2D = preload("res://assets/icons/flash_white.png")


var shimmer_material: ShaderMaterial
var shimmer_enabled := false
var shimmer_time := 0.0
var parent: Control
var tween: Tween
var playable := true : set = _set_playable
var disabled = false

func _ready():
	Events.card_aim_started.connect(_on_drag_or_aim_started)
	Events.card_drag_started.connect(_on_drag_or_aim_started)
	Events.card_aim_ended.connect(_on_drag_or_aim_ended)
	Events.card_drag_ended.connect(_on_drag_or_aim_ended)
	card_state_machine.init(self)
	
	shimmer_material = base_shimmer_material.duplicate()
	if shimmer_material:
		shimmer_material.set_shader_parameter("time", 0.0)
		shimmer_material.set_shader_parameter("shine_color", Color(1, 1, 1, 0.5))
		shimmer_material.set_shader_parameter("shine_speed", 4)
		shimmer_material.set_shader_parameter("shine_size", 0.01)
		card_art.material = shimmer_material
	
	shader_material.shader = preload("res://scenes/styleboxes/glow.gdshader")
	glow_panel.material = shader_material	

	remove_shimmer()
	remove_glow()
	
func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready

	card = value
	type_label.text = card.id
	if FileAccess.file_exists(card.texture_path):
		card_art.texture = load(card.texture_path)
		card_art.scale = size / card_art.texture.get_size()
	value_label.text = str(card.value)
	if card.is_weather():
		icon.texture = weather_icon
		type_label.text += "\nWeather"
	elif card.is_permanent():
		icon.texture = moon_icon
		type_label.text += "\nPermanent"
	else:
		icon.texture = flash_icon
		type_label.text +="\nInstant"
	icon.modulate = icon_color
	 
	
	card.set_tooltip_from_values()
		
	self.stats = get_tree().get_first_node_in_group("player").stats
	self.playable = stats.can_play_card(card)
	
	set_glow_color()
	glow_color.a = 0.2
	var icon_shader := icon_glow_panel.material.duplicate() as ShaderMaterial
	icon_shader.set_shader_parameter("color", glow_color)
	icon_glow_panel.material = icon_shader
	remove_glow()

func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		value_label.add_theme_color_override("default_color", Color.CRIMSON)
		# TODO set glow to gray
	else:
		value_label.remove_theme_color_override("default_color")
		
func _set_stats(value: Stats) -> void:
	stats = value
	stats.stats_changed.connect(_on_character_stats_changed)

func play() -> void:
	if not card:
		return
	card.play(drop_targets)
	
	if not (card.is_permanent or card.is_weather()):
		queue_free() # TODO add to discard pile

# REMINDER: set character stats from the tutorial was not implemented here!

func _on_drag_or_aim_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	disabled = true
	
func _on_drag_or_aim_ended(_card: CardUI) -> void:
	disabled = false
	self.playable = stats.can_play_card(card)

func _on_character_stats_changed() -> void:
	self.playable = stats.can_play_card(card)
	
func set_glow_color() -> void:
	if card.is_weather():
		glow_color = CustomColors.GLOW_WEATHER
	elif card.is_permanent():
		glow_color = CustomColors.GLOW_CURSED
	else:
		glow_color = CustomColors.GLOW_DEFAULT

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
	
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()
	if not playable or disabled:
		return #TODO add gray glow maybe
	add_shimmer()
	if not is_glowing_strong:
		add_glow()
	Events.card_tooltip_requested.emit(self)

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()
	remove_shimmer()
	if not is_glowing_strong:
		remove_glow()
		Events.tooltip_hide_requested.emit()

func _on_drop_point_detector_area_entered(area) -> void:
	if area.is_in_group("card_drop_area"): 
		print("Collision with card drop area")
		if not drop_targets.has(area):
			drop_targets.append(area)
			if card_state_machine.current_state.state == CardState.State.DRAGGING:
				if not is_glowing_strong:
					add_strong_glow()
					Events.card_drag_found_target.emit(self)
	elif area.is_in_group("card_target_selector"):
		print("Collision with card targeting system")
		if not is_glowing_strong:
			add_glow()
		
func _on_drop_point_detector_area_exited(area):
	drop_targets.erase(area)
	if area.is_in_group("card_drop_area") and is_glowing_strong:
		is_glowing_strong = false
		Events.card_drag_lost_target.emit(self)
		add_glow()
	elif area.is_in_group( "card_target_selector"):
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

func add_glow():
	glow_panel.visible = true
	glow_color.a = 0.5
	shader_material.set_shader_parameter("color", glow_color)
	shader_material.set_shader_parameter("glow_size", 20)

func add_strong_glow():
	is_glowing_strong = true
	glow_color.a = 0.6
	shader_material.set_shader_parameter("color", glow_color)
	shader_material.set_shader_parameter("glow_size", 50)

func remove_glow():
	# Alternatively, make glow invisible
	glow_color.a = 0.2
	shader_material.set_shader_parameter("color", glow_color)
	shader_material.set_shader_parameter("glow_size", 18)
	
	
func _process(delta):
	if shimmer_enabled and shimmer_material:
		shimmer_time += delta
		shimmer_material.set_shader_parameter("time", shimmer_time)
	elif shimmer_material:
		shimmer_material.set_shader_parameter("time", 0.0)
