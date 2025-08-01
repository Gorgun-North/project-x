extends states
class_name player_move

var input_vector : Vector2 = Vector2.ZERO



@export var powerup_handler: player_powerup_controller

var last_input_vector : Vector2 #Set the last direction where the player was moving towards for decelaration in idle state

func Physics_Update(_delta) -> void:
	
	input_vector.x = Input.get_action_strength("WASD_RIGHT") - Input.get_action_strength("WASD_LEFT")
	input_vector.y = Input.get_action_strength("WASD_DOWN") - Input.get_action_strength("WASD_UP")
	input_vector = input_vector.normalized() 
	
	body.velocity = input_vector * body.speed

	if input_vector == Vector2.ZERO:
		Transitioned.emit(self, "idle")
	else:
		last_input_vector = input_vector #Keep the last input up to date until the state changes
		
func Exit():
	body.velocity = last_input_vector * body.speed

	
