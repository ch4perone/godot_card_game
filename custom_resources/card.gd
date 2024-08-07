class_name Card
extends Resource


enum Type {Weather, Environmental, Consumable}
enum Target {SELF, SINGLE, ALL, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var value: int

@export_group("Card Visuals")
@export_file("*.png") var texture_path: String
@export_multiline var tooltip_text: String

func is_single_targeted() -> bool:
	return target == Target.SINGLE
