class_name Hand
extends HBoxContainer

func _input(_event):
	if Input.is_action_pressed("quit_game"):
		get_tree().quit()

func _ready() -> void:
	for child in get_children():
		var card_ui := child as CardUI
		card_ui.parent = self
		card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
		

func _on_card_ui_reparent_requested(child: CardUI) -> void:
	child.reparent(self)
	print("Reparented to hand")
