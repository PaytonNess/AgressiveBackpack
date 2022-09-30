extends Node2D

export(String, FILE, "*.tscn") var path_to_scene
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Exit_pressed():
	get_tree().quit()


func _on_Replay_pressed():
	if ResourceLoader.exists(path_to_scene):
		var _error = get_tree().change_scene(path_to_scene)
