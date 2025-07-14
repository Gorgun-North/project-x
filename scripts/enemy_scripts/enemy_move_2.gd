extends states
class_name enemy_move2

@export var max_speed     : float = 400.0
@export var min_speed     : float = 300
@export var pause_seconds : float = 0.3
@export var go_to_dodge_timer: float = 4.0
@export var acceptable_distance_to_player: float = 1000.0

var _pause_timer : float = 0.0

var rng = RandomNumberGenerator.new()
var speed: float
var max_navmesh_set_dest_attempts: int = 1000
var move_to_attack_player_chance: float = 0.5

var player: CharacterBody2D

@export var nav: NavigationAgent2D
@export var point_to_player_ray: RayCast2D
@export var enemy_to_player_ray: RayCast2D
@export var state_machine_controller_node: state_machine_controller
var to_dodge_timer: float

func _Entered() -> void:
	rng.randomize()
	speed = rng.randf_range(min_speed, max_speed)
	
	nav.set_target_position(_pick_new_destination(max_navmesh_set_dest_attempts))


func Physics_Update(delta: float) -> void:
	if nav.is_navigation_finished():
		body.velocity = Vector2.ZERO
		_pause_timer -= delta
		if _pause_timer <= 0.0:
			nav.set_target_position(_pick_new_destination(max_navmesh_set_dest_attempts))
		return

	
	var steer_target: Vector2 = nav.get_next_path_position()
	body.look_at(nav.get_next_path_position())
	var dir: Vector2 = (steer_target - body.global_position).normalized()
	
	body.velocity = dir * max_speed

func check_for_sight_to_player(ray: RayCast2D, origin_point: Vector2, destination_object: Node2D) -> bool:
	ray.global_position = origin_point
	ray.target_position = ray.to_local(destination_object.global_position)
	
	if ray.is_colliding():
		if ray.get_collider() == destination_object:
			return true
	return false

func _pick_new_destination(attempts: int) -> Vector2:
	
	
	var map_rid: RID = nav.get_navigation_map()
	
	for i in attempts:
	# NavigationServer2D can hand us a genuine point ON the mesh:
		var random_point : Vector2 = NavigationServer2D.map_get_random_point(map_rid, 1, true)
		speed = rng.randf_range(min_speed, max_speed)
		var point_distance_to_player: float = random_point.distance_to(player.global_position)
		
		var move_to_attack_player_dice_roll: float = rng.randf_range(0.0, 1.0)
		
		if not random_point:
			continue
		
		if !nav.is_target_reachable():
			continue
		
		if !player:
			push_error("no player selected, code wont work")
			continue
			
		if point_distance_to_player > acceptable_distance_to_player:
			continue
			
		if move_to_attack_player_dice_roll < move_to_attack_player_chance:
			if !check_for_sight_to_player(point_to_player_ray, random_point, player):
				continue
				
		_pause_timer = pause_seconds
		return random_point
			
	return body.global_position
	


func _ready() -> void:
	to_dodge_timer = go_to_dodge_timer
	player = get_tree().get_first_node_in_group("Player")
	
func _physics_process(delta: float) -> void:
	if state_machine_controller_node == null:
		push_error("State machine_controller not initialized in enemy_move_script")
		return
	
	#If current state is not move, dont go into the dodge state.
	if state_machine_controller_node.current_state != state_machine_controller_node.states_dict.get("move"):
		return
		
	if enemy_to_player_ray.is_colliding():
		if enemy_to_player_ray.get_collider() != player:
			return
		
	to_dodge_timer -= delta
	if to_dodge_timer <= 0.0:
		var maximum_new_dodge_time: float = 5.0
		var new_dodge_time = rng.randf_range(to_dodge_timer, maximum_new_dodge_time)
		
		to_dodge_timer = new_dodge_time
		Transitioned.emit(self, "dodge")
