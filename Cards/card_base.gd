extends MarginContainer


@onready var cardDB = preload("res://Assets/Cards/cardsDB.gd")
var cardName = "Sunshine"
@onready var cardInfo = cardDB.DATA[cardDB.CARDS.get(cardName)]
@onready var cardArtPath = "res://Assets/Cards/Art/" + cardInfo["FILE"]
@onready var cardBorderPath = "res://Assets/Cards/" + "card_border_" + cardInfo["TYPE"].to_lower() + ".png"
 
# Called when the node enters the scene tree for the first time.
func _ready():
	var cardSize = size
	$Border.texture = load(cardBorderPath)
	$Border.scale *= cardSize / $Border.texture.get_size()
	print(cardArtPath)
	$Card.texture = load(cardArtPath)
	$Card.scale *= cardSize / $Card.texture.get_size()
	print("CardIsReady: " + str(cardInfo)) # Replace with function body.
	$Bars/TopBar/Name/CenterContainer/Name.text = cardInfo["NAME"]
	$Bars/TopBar/Name/CenterContainer/Name.z_index=1
	$Bars.visible = false
	# $Bars/TopBar/Name/NinePatchRect.visible = true
	# connect("mouse_entered", self, "_on_mouse_entered")
	# Ensure the node path is correct and the node has the signal
	if has_signal("mouse_entered"):
		connect("mouse_entered", Callable(self, "_on_mouse_entered"))
		connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	else:
		print("mouse_entered signal not found")

func _on_mouse_entered():
	$Bars.visible = true
	print("Mouse entered")


func _on_mouse_exited():
	$Bars.visible = false
	print("Mouse exited")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

