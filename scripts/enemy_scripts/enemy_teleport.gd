extends states
class_name enemy_teleport

const TELEPORT_ABILITY_LEVEL_UNLOCK: int = 3
var track_health: int

@export var state_machine_controller_instance: state_machine_controller
@export var pickup_powerup_instance: enemy_pickup_powerup

@export var teleport_distance: float =  1000.0
@export var random_teleport_range: float = 0.75
@export var check_teleport_pos_ray: RayCast2D 

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	call_deferred("_ready_got_hit")
	
func _ready_got_hit() -> void:
	if body is entity:
		body.got_hit.connect(_on_got_hit)
		
func _on_got_hit(attacker: entity, hit_dir: Vector2, _knockback_force: float, _knockback_dur: float):
	var root = get_tree().current_scene
	print(state_machine_controller_instance.current_state)
	
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("melee_attack"):
		return
		
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("pickup_powerup"):
		return
		
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("dodge"):
		return
		
	if pickup_powerup_instance.is_powerup_picked_up == false:
		return
	
	if !attacker:
		return
	
	if !attacker.name.begins_with("Player"):
		return
		
	if root is game_controller:
		if root.current_stage < TELEPORT_ABILITY_LEVEL_UNLOCK:
			return
	
	var distance_to_player = body.global_position.distance_to(attacker.global_position)
	var base_distance = teleport_distance + distance_to_player
	
	var main_dir = -hit_dir.normalized()
	
	var perpendicular = Vector2(-main_dir.y, main_dir.x)
	
	var lateral_offset = randf_range(-random_teleport_range, random_teleport_range) * base_distance * random_teleport_range
	var position_behind_player = body.global_position + main_dir * base_distance + perpendicular * lateral_offset
	
	check_teleport_pos_ray.global_position = body.global_position
	check_teleport_pos_ray.target_position = check_teleport_pos_ray.to_local(position_behind_player)
	
	check_teleport_pos_ray.force_raycast_update()
	
	print("I TELEPORT!")
	if check_teleport_pos_ray.is_colliding():
		body.global_position = check_teleport_pos_ray.get_collision_point()
	else:
		body.global_position = position_behind_player
		
	
		
		
		
	
	
