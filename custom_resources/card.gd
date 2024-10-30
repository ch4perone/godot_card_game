class_name Card
extends Resource


enum Type {Weather, Curse, Instant}
enum Target {SELF, SINGLE, ALL_CARDS_ON_BOARD} #, EVERYONE

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var value: int
@export var temp_change: float
@export var humid_change: float
@export var orchard_change: int

@export_group("Card Visuals")
@export_file("*.png") var texture_path: String
@export var card_name: String
@export_multiline var tooltip_text: String

func set_tooltip_from_values():
	if card_name == "":
		var splits = id.split("_")
		for s in splits:
			card_name += s.capitalize() + " "
		
	var tooltip_default_text := ""
	
	if orchard_change != 0:
		var orchard_sign = ""
		if orchard_change > 0:
			orchard_sign = "+" 
		tooltip_default_text += "[apple] " + orchard_sign + str(orchard_change) + "\n"
	
	if temp_change != 0:
		var temp_sign = ""
		if temp_change > 0:
			temp_sign = "+" 
		tooltip_default_text += "Temperature " + temp_sign + str(temp_change) + "°C\n"

	if humid_change != 0:
		var humid_sign = ""
		if humid_change > 0:
			humid_sign = "+" 
		tooltip_default_text += "Soil humidity " + humid_sign + str(humid_change) + "%"

	tooltip_text = tooltip_default_text + tooltip_text

func is_single_targeted() -> bool:
	return target == Target.SINGLE

func is_weather() -> bool:
	return type == Type.Weather
	
func is_permanent() -> bool:
	return type == Type.Curse

func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	
	var tree := targets[0].get_tree()

	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_CARDS_ON_BOARD:
			print("ALL CARDS ON BOARD is not implemented Error")
			return []
		_:
			return []

func play(targets: Array[Node]) -> void: # In tutorial this also gets stats, but it didn't work so I access player instead
	Events.card_played.emit(self)
	var tree := targets[0].get_tree()
	var player := tree.get_nodes_in_group("player")[0]
	player.change_fortune(value)
	
	if is_single_targeted():
		apply_default_effects(targets)
		apply_effects(targets)
	else:
		apply_default_effects(_get_targets(targets))
		apply_effects(_get_targets(targets))

func apply_default_effects(targets: Array[Node]) -> void:
	if orchard_change != 0:
		var effect := ChangeOrchardEffect.new()
		effect.value = orchard_change
		effect.execute(targets)
	if temp_change != 0.0:
		var effect := ChangeTemperatureEffect.new()
		effect.value = temp_change
		effect.execute(targets)
	if humid_change != 0.0:
		var effect := ChangeHumidityEffect.new()
		effect.value = humid_change
		effect.execute(targets)

func apply_effects(_targets: Array[Node]) -> void:
	print("in virtual")
	pass
