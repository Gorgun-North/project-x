extends player_states
class_name player_idle

@export var decelaration: float

func Physics_Update(_delta) -> void:
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("WASD_RIGHT") - Input.get_action_strength("WASD_LEFT")
	input_vector.y = Input.get_action_strength("WASD_DOWN") - Input.get_action_strength("WASD_UP")
	input_vector = input_vector.normalized()
	
	
	if input_vector == Vector2.ZERO:
		#Smoothly stops the movement of the player once they stop moving.
		body.velocity = body.velocity.move_toward(Vector2.ZERO, decelaration * _delta)
	
	if input_vector != Vector2.ZERO:
		Transitioned.emit(self, "move")
