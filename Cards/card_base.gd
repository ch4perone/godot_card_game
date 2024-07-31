extends MarginContainer


@onready var cardDB = preload("res://Assets/Cards/cardsDB.gd")
var card_id = "RosePetalTea"
@onready var card_info = cardDB.DATA[cardDB.CARDS.get(card_id)]
@onready var card_art_path = "res://Assets/Cards/Art/" + card_info["FILE"]
@onready var card_border_path = "res://Assets/Cards/" + "card_border_" + card_info["TYPE"].to_lower() + ".png"
@onready var card_icon_path = "res://Assets/Cards/card_icon.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	var cardSize = size
	$Border.texture = load(card_border_path)
	$Border.scale *= cardSize / $Border.texture.get_size()
	print(card_art_path)
	$Card.texture = load(card_art_path)
	$Card.scale *= cardSize / $Card.texture.get_size()
	print("CardIsReady: " + str(card_info)) # Replace with function body.
	$Bars/TopBar/Name/CenterContainer/Name.text = card_info["NAME"]
	$Bars/TopBar/Name/CenterContainer/Name.z_index=1
	$Bars.visible = false
	set_icon_label()
	
	
	if has_signal("mouse_entered"):
		connect("mouse_entered", Callable(self, "_on_mouse_entered"))
		connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	else:
		print("mouse_entered signal not found")

func set_icon_label():
	
	var icon = $IconVBoxContainer/IconHBoxContainer/TextureRect
	icon.texture = load(card_icon_path)

	icon.expand = true
	icon.stretch_mode = TextureRect.EXPAND_KEEP_SIZE
	var cost = card_info["COST"]
	var sign = "+" if cost > 0 else "-" if cost < 0 else ""
	var label = $IconVBoxContainer/IconHBoxContainer/TextureRect/IconText
	
	if cost > 0:
		label.push_color(Color("darkgreen"))
	elif cost < 0:
		label.push_color(Color("red"))
	label.push_bold()
	label.append_text(str(sign,cost))
	label.pop()


func _on_mouse_entered():
	$Bars.visible = true
	print("Mouse entered")


func _on_mouse_exited():
	$Bars.visible = false
	print("Mouse exited")

func _input(event):
	if Input.is_action_pressed("quit_game"):
		get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

