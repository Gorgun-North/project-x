extends states
class_name enemy_move

@export var speed: float

@export var nav: NavigationAgent2D
@export var move_dest_ray: RayCast2D

var target: Vector2 = Vector2.ZERO

#Variable for when the target finds the distance to the nav target acceptable
@export var target_reached_distance: float 

var min_random_target_distance: float = -1000
var max_random_target_distance: float = 1000

var rng = RandomNumberGenerator.new()

signal set_new_nav_destination

func Entered():
	rng.randomize()
	set_new_nav_destination.connect(on_new_nav_destination)
	set_new_nav_destination.emit()
	

#Function to initialize the destination coordinates
func init_dest_coords(min_coords: float, max_coords: float) -> Vector2:
	#rng.randomize()
	
	var random_coords_x = rng.randf_range(min_coords, max_coords)
	var random_coords_y = rng.randf_range(min_coords, max_coords)
	
	return Vector2(random_coords_x, random_coords_y)
		
func Physics_Update(_delta: float) -> void:
	if target != Vector2.ZERO:
		
		print(body.global_transform.origin.distance_to(target))
		if body.global_transform.origin.distance_to(target) < target_reached_distance:
			
			body.velocity = Vector2.ZERO
			set_new_nav_destination.emit()
		
		var current_agent_pos = body.global_transform.origin
		var next_path_pos = nav.get_next_path_position()
		body.look_at(next_path_pos) #To look at the next movement position
		var new_vel = current_agent_pos.direction_to(next_path_pos) * speed
		
		if nav.avoidance_enabled:
			nav.set_velocity(new_vel)
		elif !nav.avoidance_enabled:
			_on_navigation_agent_2d_velocity_computed(new_vel)
			
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	body.velocity = safe_velocity
	
func on_new_nav_destination():
	if move_dest_ray == null:
		push_error("No raycast initialized, code wont work!")
		return
	
	move_dest_ray.global_position = body.global_position
	
	var local_dir = init_dest_coords(min_random_target_distance, max_random_target_distance)
	move_dest_ray.target_position = local_dir
	move_dest_ray.force_raycast_update()
	
	
	if move_dest_ray.is_colliding():
		target = move_dest_ray.get_collision_point()
		move_dest_ray.target_position = move_dest_ray.to_local(target)
	else:
		target = move_dest_ray.to_global(local_dir)
	
	
	nav.target_position = target
