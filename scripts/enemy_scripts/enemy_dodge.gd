extends states
class_name enemy_dodge

@export var speed: float

@export var enemy_to_player_ray: RayCast2D
@export var nav: NavigationAgent2D
@export var move_dest_ray: RayCast2D
@export var state_machine_controller_instance: state_machine_controller

var target: Vector2 = Vector2.ZERO

#Variable for when the target finds the distance to the nav target acceptable
@export var target_reached_distance: float 
@export var go_to_dodge_timer: float = 2.0
var to_dodge_timer: float

var min_random_target_distance: float = -800
var max_random_target_distance: float = 800

var player: CharacterBody2D
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	to_dodge_timer = go_to_dodge_timer
	

func Entered():
	print("I DODGE!")
	rng.randomize()
	new_nav_destination()
	

#Function to initialize the destination coordinates
func init_dest_coords(min_coords: float, max_coords: float) -> Vector2:
	#rng.randomize()
	
	var random_coords_x = rng.randf_range(min_coords, max_coords)
	var random_coords_y = rng.randf_range(min_coords, max_coords)
	
	return Vector2(random_coords_x, random_coords_y)
		
func Physics_Update(_delta: float) -> void:
	if target != Vector2.ZERO:
		
		if body.global_transform.origin.distance_to(target) < target_reached_distance:
			Transitioned.emit(self, "idle")
		
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
	
func new_nav_destination():
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
	
func _physics_process(delta: float) -> void:
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("melee_attack"):
		return
	
	
	if enemy_to_player_ray.is_colliding():
		if enemy_to_player_ray.get_collider() != player:
			return
	
	to_dodge_timer -= delta
	if to_dodge_timer <= 0.0:
		var maximum_new_dodge_time: float = 5.0
		var new_dodge_time = rng.randf_range(to_dodge_timer, maximum_new_dodge_time)
		
		to_dodge_timer = new_dodge_time
		Transitioned.emit(state_machine_controller_instance.current_state, "dodge")
