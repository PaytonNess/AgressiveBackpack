class_name DebugObject
extends Area2D

var taken = false

var id = 2
#onready var inv = $"../Inventory"
#var inv = get_tree().get_root().find_node("Inventory")

func _on_DebugObject_body_entered(body):
	if not taken and body is Player:
		taken = true
		print("Picked Up Object: "+str(id))
		var inv = $"../Inventory"
		inv.add_item(id)
		queue_free() #This kills the object
