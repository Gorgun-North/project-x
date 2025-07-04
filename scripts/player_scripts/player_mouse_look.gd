extends Node

@export var body: CharacterBody2D

func _process(delta: float) -> void:
	#Checks if the body is selected and if so, lets the characterbody2d look at the mouse
	if body:
		var mouse_pos = body.get_global_mouse_position()
		body.look_at(mouse_pos)
	else:
		print("body is not selected, attach it to this node: ", self)
