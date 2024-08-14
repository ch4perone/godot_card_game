class_name Card
extends Resource


enum Type {Weather, Environmental, Consumable}
enum Target {SELF, SINGLE, ALL_CARDS_ON_BOARD} #, EVERYONE

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var is_permanent: bool
@export var value: int

@export_group("Card Visuals")
@export_file("*.png") var texture_path: String
@export_multiline var tooltip_text: String

func is_single_targeted() -> bool:
	return target == Target.SINGLE
	
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
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))

func apply_effects(_targets: Array[Node]) -> void:
	print("in virtual")
	pass
