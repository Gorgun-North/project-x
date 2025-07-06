extends states
class_name player_dodge


@export var dodge_speed: float = 700
@export var dodge_duration: float = 0.3

var dodge_direction: Vector2
var dodge_timer: float = 0.0

func Entered() -> void:
	dodge_timer = dodge_duration
	var mouse_pos = body.get_global_mouse_position()
	dodge_direction = (mouse_pos - body.global_position).normalized()
	
func Physics_Update(delta) -> void:
	if dodge_direction != Vector2.ZERO:
		dodge_timer -= delta
		body.velocity = dodge_direction * dodge_speed
		if dodge_timer <= 0.0:
			Transitioned.emit(self, "idle")
