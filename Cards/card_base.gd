extends MarginContainer


@onready var cardDB = preload("res://Assets/Cards/cardsDB.gd")
var card_id = "Sunshine"#"RosePetalTea"
@onready var card_info = cardDB.DATA[cardDB.CARDS.get(card_id)]
@onready var card_art_path = "res://Assets/Cards/Art/" + card_info["FILE"]
@onready var card_border_path = "res://Assets/Cards/" + "card_border_" + card_info["TYPE"].to_lower() + ".png"
@onready var card_icon_path = "res://Assets/Cards/card_icon.png"
@onready var clover_icon_path = "res://Assets/Cards/clover_icon.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_card_design()
	set_cardui()
	set_icon_label()
	
	if has_signal("mouse_entered"):
		connect("mouse_entered", Callable(self, "_on_mouse_entered"))
		connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	else:
		print("mouse_entered signal not found")

func set_card_design():
	var cardSize = size
	$Border.texture = load(card_border_path)
	$Border.scale *= cardSize / $Border.texture.get_size()
	print(card_art_path)
	$Card.texture = load(card_art_path)
	$Card.scale *= cardSize / $Card.texture.get_size()

func set_cardui():
	$CardUI/TopVBoxContainer/TopBar/Name/CenterContainer/Name.text = card_info["NAME"]
	$CardUI/TopVBoxContainer/TopBar/Name/CenterContainer/Name.z_index=1
	
	if "FLAVOR_TEXT" in card_info.keys():
		print("flavor test")
		var flavor_label = $CardUI/BottomVBoxContainer/BottomBar/VBoxContainer/FlavorText
		flavor_label.push_italics()
		flavor_label.add_text("\"" + card_info["FLAVOR_TEXT"] + "\"")
		flavor_label.z_index=1
		flavor_label.pop()
	if "TEXT" in card_info.keys():
		var card_text_label = $CardUI/BottomVBoxContainer/BottomBar/VBoxContainer/CardText
		card_text_label.add_text(card_info["TEXT"])
		card_text_label.z_index=1
		card_text_label.pop()
	
	$CardUI.visible = false

func set_icon_label():
	
	var icon = $IconVBoxContainer/IconHBoxContainer/TextureRect
	icon.texture = load(card_icon_path)

	icon.expand = true
	icon.stretch_mode = TextureRect.EXPAND_KEEP_SIZE
	var cost = card_info["COST"]
	var sign = "+" if cost > 0 else "-" if cost < 0 else ""
	var label = $IconVBoxContainer/IconHBoxContainer/TextureRect/IconText
	var t=Texture.new()
	t=load(clover_icon_path)

	if cost > 0:
		label.push_color(Color("darkgreen"))
	elif cost < 0:
		label.push_color(Color("red"))
	label.push_bold()
	label.append_text(str(sign,cost))
	
	
	label.add_image(t,20,20)
	label.pop()


func _on_mouse_entered():
	$CardUI.visible = true
	print("Mouse entered")


func _on_mouse_exited():
	$CardUI.visible = false
	print("Mouse exited")

func _input(_event):
	if Input.is_action_pressed("quit_game"):
		get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

