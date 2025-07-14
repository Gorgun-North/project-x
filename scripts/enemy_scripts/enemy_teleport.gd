extends states
class_name enemy_teleport

const TELEPORT_ABILITY_LEVEL_UNLOCK: int = 2
var track_health: int

@export var teleport_distance: float =  1000.0
@export var random_teleport_range: float = 0.75
@export var check_teleport_pos_ray: RayCast2D 

var rng = RandomNumberGenerator.new()

signal got_hit_teleport

func _ready() -> void:
	call_deferred("_ready_got_hit")
	
func _ready_got_hit() -> void:
	if body is entity:
		body.got_hit.connect(_on_got_hit)
	

func Entered() -> void:
	if body is entity:
		track_health = body.health
	
	var root = get_tree().current_scene
	
	if root is not game_controller:
		Transitioned.emit(self, "Idle")
	
	if root.current_stage < TELEPORT_ABILITY_LEVEL_UNLOCK:
		Transitioned.emit(self, "Idle")



func _on_got_hit(attacker: entity, hit_dir: Vector2, knockback_force: float, knockback_dur: float):
	var root = get_tree().current_scene
	
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
	
	if check_teleport_pos_ray.is_colliding():
		body.global_position = check_teleport_pos_ray.get_collision_point()
	else:
		body.global_position = position_behind_player
		
	
		
		
		
	
	
