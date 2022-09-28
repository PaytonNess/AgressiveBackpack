extends RigidBody2D

var disabled = false


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#($Timer as Timer).start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Book_body_entered(body):
	#print("I have entered body: "+str(body))
	#Add check if enemy here
	($Timer as Timer).start()
	#pass # Replace with function body.

func disable():
	if disabled:
		return

	($AnimationPlayer as AnimationPlayer).play("shutdown")
	disabled = true
