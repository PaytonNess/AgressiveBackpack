class_name Pickup
extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var taken = false

var bookSprite = load("res://Items/Book16px.png") 
var eyeSprite = load("res://Items/Eye16px.png")
var hammerSprite = load("res://Items/Hammer16px.png")
var id = 0 #get ID as input when spawn, set to 0 (temporarilyeye) by default
var item_dict_obj = {0: eyeSprite, 1: hammerSprite, 2: bookSprite}
#ex: $Sprite.texture = eyeSprite

func init(inputID): #Constructor
	id = inputID
	$Sprite.texture = item_dict_obj[id]
	print("Constructed pickup with id "+str(id)+" at "+str(position))


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Node2D_body_entered(body):
	if not taken and body is Player:
		taken = true
		print("Picked Up Object: "+str(id))
		var inv = $"../Inventory"
		inv.add_item(id)
		queue_free() #This kills the object
