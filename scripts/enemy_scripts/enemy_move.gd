extends states
class_name enemy_move

@export var speed: float

@export var nav: NavigationAgent2D

var target: CharacterBody2D

func Entered():
	target = get_tree().get_first_node_in_group("Player")
	if target == null:
		push_error("Could not find Player in 'Player' group!")
		
func Physics_Update(_delta: float) -> void:
	if target:
		nav.target_position = target.global_transform.origin
		
		var current_agent_pos = body.global_transform.origin
		var next_path_pos = nav.get_next_path_position()
		body.look_at(next_path_pos) #To look at the next movement position
		var new_vel = current_agent_pos.direction_to(next_path_pos) * speed
		
		if nav.avoidance_enabled:
			nav.set_velocity(new_vel)
		else:
			_on_navigation_agent_2d_velocity_computed(new_vel)
			


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	body.velocity = safe_velocity
