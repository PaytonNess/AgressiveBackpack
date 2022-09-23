extends Node

# Inventory array, stores IDs of items
var inventory = []
#Dictionary of IDs
#var item_dict = {"HP Potion": 0, "Knife": 1, "Spellbook": 2, "Bomb": 3, 
#"Poison": 4, "Bone": 5, "Shoe": 6, "Arm": 7, "Rat": 8}
var item_dict = {0: "HP Potion", 1: "Knife", 2: "Spellbook", 3: "Bomb", 
4: "Poison", 5: "Bone", 6: "Shoe", 7: "Arm", 8: "Rat"}
# id 0: HP
# id 1: Knife
# id 2: Spell
# id 3: Bomb
# id 4: Poison
# id 5: Bone
# id 6: Shoe
# id 7: Arm
# id 8: Rat

var inventory_size = 0


#randomization
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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.

#In this script, only used for debug
func _process(delta):
	#add item
	if (Input.is_key_pressed(KEY_F)):
		#get random item to add
		rng.randomize()
		var i = rng.randi_range(0, 8)
		add_item(i)
	#throw item
	if (Input.is_key_pressed(KEY_R)):
		if(inventory.size() > 0): throw_item()
		pass
	

