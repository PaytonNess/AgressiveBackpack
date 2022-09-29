extends Area2D

var Pickup = preload("res://items/Pickup.tscn")
var rng = RandomNumberGenerator.new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#spawn_pickup()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_pickup():
	#get random item to add
	rng.randomize()
	var i = rng.randi_range(0, 2)
	var e = Pickup.instance()
	e.init(i)
	e.position = position
	get_parent().add_child(e)
