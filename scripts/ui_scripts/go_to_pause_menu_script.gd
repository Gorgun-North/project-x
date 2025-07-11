extends Node

@export var pausemenu_node: pausemenu

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ESC"):
		if pausemenu_node:
			if get_tree().paused == false: 
					pausemenu_node.pause()
			elif get_tree().paused == true:
				pausemenu_node.resume()
		
