extends Node

# Inventory array, stores IDs of items
var inventory = []
#Dictionary of IDs
var item_dict = {"HP Potion": 0, "Knife": 1, "Spellbook": 2, "Bomb": 3, 
"Poison": 4, "Bone": 5, "Shoe": 6, "Arm": 7, "Rat": 8}
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


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_item(itemID):
	#Receives ID of item being picked up
	inventory.push_front(itemID)

func throw_item():
	#Returns ID of item being withdrawn from bag
	return inventory.pop_front()

func get_current_item_id():
	return inventory[0]

func get_current_item_name():
	return item_dict[inventory[0]]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

