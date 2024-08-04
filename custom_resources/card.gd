class_name Card
extends Resource


enum Type {Weather, Environmental, Consumable}
enum Target {SELF, SINGLE, ALL, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target


func is_single_targeted() -> bool:
	return type == Target.SINGLE