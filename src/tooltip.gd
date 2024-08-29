class_name Tooltip
extends PanelContainer

@onready var fade_seconds := 0.2
@onready var tooltip_icon := %TooltipIcon
@onready var tooltip_text_label := %TooltipText

var tween: Tween

func _ready() -> void:
	Events.card_tooltip_requested.connect(show_tooltip)
	Events.tooltip_hide_requested.connect(hide_tooltip)
	modulate = Color.TRANSPARENT
	hide()


func show_tooltip(card_ui: CardUI) -> void:
	if tween:
		tween.kill()
	
	tooltip_icon.texture = card_ui.card_art.texture
	tooltip_text_label.text = card_ui.card.tooltip_text

	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", Color.WHITE, fade_seconds)


func hide_tooltip() -> void:
	if tween:
		tween.kill()
	
	hide_animation()

func hide_animation() -> void:
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_seconds)
	tween.tween_callback(hide)
