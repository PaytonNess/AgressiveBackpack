class_name DebugObject
extends Area2D

var taken = false

func _on_body_enter(body):
	if not taken and body is Player:
		print("DOME!")


