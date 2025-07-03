extends player_states
class_name player_move

#Exported values for speed and such for quick adjustments
@export var player_speed : float

var input_vector : Vector2 = Vector2.ZERO

var last_input_vector : Vector2 #Set the last direction where the player was moving towards for decelaration in idle state

#Basic movement applied to character
func Physics_Update(_delta) -> void:
	
	input_vector.x = Input.get_action_strength("WASD_RIGHT") - Input.get_action_strength("WASD_LEFT")
	input_vector.y = Input.get_action_strength("WASD_DOWN") - Input.get_action_strength("WASD_UP")
	input_vector = input_vector.normalized() 
	
	body.velocity = input_vector * player_speed

	if input_vector == Vector2.ZERO:
		Transitioned.emit(self, "idle")
	else:
		last_input_vector = input_vector #Keep the last input up to date until the state changes
		
func Exit():
	body.velocity = last_input_vector * player_speed
	
	
