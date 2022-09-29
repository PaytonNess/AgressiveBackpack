extends Area2D

var Enemy = preload("res://enemy/Enemy.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	_spawn_enemy()
	#print("Enemy Spawner spawned")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _spawn_enemy():
	#print("Enemy has spawned!")
	var e = Enemy.instance()
	e.position = position
	get_parent().add_child(e)
