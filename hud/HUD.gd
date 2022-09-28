extends CanvasLayer

var bookSprite = load("res://Items/Book32px.png") 
var eyeSprite = load("res://Items/Eye32px.png")
var hammerSprite = load("res://Items/Hammer32px.png")
var nullSprite = load("res://Items/ItemNone.png")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setItemSprite(id):
	print("Called item: "+str(id))
	if(id == 0):
		$ItemSprite.texture = eyeSprite
	elif(id == 1):
		$ItemSprite.texture = hammerSprite
	elif(id == 2):
		$ItemSprite.texture = bookSprite
	else:
		$ItemSprite.texture = nullSprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
