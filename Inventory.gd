extends Node

# Inventory array, stores IDs of items
var inventory = []
onready var player = get_tree().get_root().find_node("Player", true, false)
#Dictionary of IDs
#var item_dict = {"HP Potion": 0, "Knife": 1, "Spellbook": 2, "Bomb": 3, 
#"Poison": 4, "Bone": 5, "Shoe": 6, "Arm": 7, "Rat": 8}
var item_dict = {0: "Eye", 1: "Hammer", 2: "Book", 3: "Bomb", 
4: "Poison", 5: "HP Potion", 6: "Shoe", 7: "Arm", 8: "Rat"}

#Objects to be thrown
#var Bullet = preload("res://DebugObject.tscn")
var Book = preload("res://items/Book.tscn")
var Eye = preload("res://items/Eye.tscn")
var Hammer = preload("res://items/Hammer.tscn")

var Pickup = preload("res://items/Pickup.tscn")

var item_dict_obj = {0: Eye, 1: Hammer, 2: Book, 3: "Bomb", 
4: "Poison", 5: "HP Potion", 6: "Shoe", 7: "Arm", 8: "Rat"}

# id 0: Eye
# id 1: Hammer
# id 2: Book
# id 3: Bomb
# id 4: Poison
# id 5: HP
# id 6: Shoe
# id 7: Arm
# id 8: Rat

var inventory_size = 0


#randomization (debug only)
var rng = RandomNumberGenerator.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_item(itemID):
	#Receives ID of item being picked up
	inventory.push_front(itemID)
	inventory_size += 1
	display_current_item_debug(true)
	
func throw_item():
	#Returns ID of item being withdrawn from bag
	var i = inventory.pop_front()
	if(inventory.size() > 0): display_current_item_debug(true)
	else: display_current_item_debug(false)
	
	player.throw_object(item_dict_obj[i].instance())
	
	#debug only:
	print("Threw ID:"+str(i)+" ("+item_dict[i]+")")
	return i

func get_current_item_id():
	return inventory[0]

func get_current_item_name():
	return item_dict[inventory[0]]
	
func display_current_item_debug(var hasItem):
	var labelCount = get_tree().get_root().find_node("_dItemCountLabel", true, false)
	labelCount.text = "Item Count: "+str(inventory_size)
	
	var label = get_tree().get_root().find_node("_dCurrentItemLabel", true, false)
	if(hasItem):
		label.text = "Current Item: "+item_dict[inventory[0]]
	else:
		label.text = "Current Item: NONE"
	
func has_item():
	#Returns true if backpack not empty, false if empty
	if (inventory.size() > 0): return true
	else: return false

#func _shot_bullet():
#	var shoot_time = 0
#	var bi = Bullet.instance()
#	var ss = 1.0
#	var pos = player.position * Vector2(ss, 1.0)
#
#	bi.position = pos
#	get_parent().add_child(bi)
#
#	bi.linear_velocity = Vector2(400.0 * ss, -40)
#
#	#add_collision_exception_with(bi) # Make bullet and this not collide.



# Called every frame. 'delta' is the elapsed time since the previous frame.

#In this script, only used for debug
func _process(delta):
	#add item
	if (Input.is_key_pressed(KEY_F)):
		#get random item to add
		rng.randomize()
		var i = rng.randi_range(0, 2)
		#add_item(i)
		var e = Pickup.instance()
		e.init(i)
		e.position = Vector2(player.position.x+25, player.position.y)
		get_parent().add_child(e)
		
	#throw item
#	if (Input.is_key_pressed(KEY_R)):
#		if(inventory.size() > 0): throw_item()
#		pass
#

