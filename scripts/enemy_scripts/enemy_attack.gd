extends states
class_name enemy_attack

@export var state_machine_controller_node: state_machine_controller
@export var enemy_to_player_ray          : RayCast2D

@export var enemy_hitbox_size: float = 70.0

@export var go_to_shoot_state_timer: float = 5.0
var shoot_state_timer: float

@export var attack_windup_timer_duration: float = 0.5
var attack_windup_timer: float

var target    : Vector2
var bullet_spawn_point_multiplier: float = 1.2

func _ready() -> void:
	shoot_state_timer = go_to_shoot_state_timer

func _physics_process(delta: float) -> void:
	var to_player_ray = enemy_to_player_ray.get_collider()
	
	if state_machine_controller_node == null:
		push_error("State machine_controller not initialized in enemy_attack_script")
		return
	
	#If current state is not move, dont go into the dodge state.
	if state_machine_controller_node.current_state \
	!= state_machine_controller_node.states_dict.get("move"):
		return
		
	shoot_state_timer -= delta
	if shoot_state_timer <= 0.0:
		
		if to_player_ray and to_player_ray.name.begins_with("exploding"):
			print("bro really just tried to blow himself up 💀")
			return
		
		if to_player_ray and !to_player_ray.name.begins_with("Player"):
			return
			
		
		shoot_state_timer = go_to_shoot_state_timer
		Transitioned.emit(state_machine_controller_node.current_state, "attack")
		
func Entered() -> void:
	var collider := enemy_to_player_ray.get_collider()
	if collider and collider.name.begins_with("Player"):
		target = collider.global_position
	
	
	#body.look_at(target)
	body.velocity = Vector2.ZERO
	attack_windup_timer = attack_windup_timer_duration
	
func Physics_Update(delta) -> void:
	
	attack_windup_timer -= delta
	
	if attack_windup_timer <= 0.0:
		var bullet_instance = preload("res://scenes/object_scenes/bullet.tscn").instantiate()
		var bullet_dir  : Vector2 = (target - body.global_position).normalized()
		var shoot_angle : float   = bullet_dir.angle()
		
		var bullet_spawn_distance : float = enemy_hitbox_size * bullet_spawn_point_multiplier
		
		if body is entity:
			bullet_instance.setup(target, body)
		bullet_instance.global_position = body.global_position + bullet_dir * bullet_spawn_distance
		bullet_instance.rotation = shoot_angle
		get_tree().root.add_child(bullet_instance)
		
		Transitioned.emit(self, "move")
