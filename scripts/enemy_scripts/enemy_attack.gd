extends states
class_name enemy_attack

@export var state_machine_controller_node: state_machine_controller
@export var enemy_to_player_ray          : RayCast2D

@export var enemy_hitbox_size: float = 70.0

@export var go_to_shoot_state_timer: float = 5.0
var shoot_state_timer: float

@export var attack_windup_timer_duration: float = 0.5
@export var double_damage_time_duration: float = 5.0
@export var powerup_damage_rate_of_fire: float = 0.25
var double_damage_timer: float
var is_doing_double_damage: bool = false

var attack_windup_timer: float

var target    : Vector2
var bullet_spawn_point_multiplier: float = 1.2


func _ready() -> void:
	call_deferred("_set_attack_timer")
	
	double_damage_timer = double_damage_time_duration

func _set_attack_timer():
	var equipped_weapon = body.held_weapon.weapon_instance
	shoot_state_timer = equipped_weapon.rate_of_fire
	

func _physics_process(delta: float) -> void:
	var to_player_ray = enemy_to_player_ray.get_collider()
	
	if !body or !body.held_weapon:
		return
	
	var equipped_weapon = body.held_weapon.weapon_instance
	
	if equipped_weapon.get_bullets_left() <= 0:
		return
	
	if state_machine_controller_node == null:
		push_error("State machine_controller not initialized in enemy_attack_script")
		return
	
	#If current state is not move, dont go into the dodge state.
	if state_machine_controller_node.current_state != state_machine_controller_node.states_dict.get("move") \
	and state_machine_controller_node.current_state != state_machine_controller_node.states_dict.get("pickup_powerup"):
		return
		
	shoot_state_timer -= delta
	if shoot_state_timer <= 0.0:
		
		if to_player_ray and to_player_ray.name.begins_with("exploding"):
			print("bro really just tried to blow himself up 💀")
			return
		
		if to_player_ray and !to_player_ray.name.begins_with("Player"):
			return
			
		
		shoot_state_timer = equipped_weapon.rate_of_fire
		Transitioned.emit(state_machine_controller_node.current_state, "attack")
		
func Entered() -> void:
	
	var collider := enemy_to_player_ray.get_collider()
	if collider and collider.name.begins_with("Player"):
		target = collider.global_position
	
	
	#body.look_at(target)
	body.velocity = Vector2.ZERO
	attack_windup_timer = attack_windup_timer_duration
	
func Physics_Update(delta) -> void:
	
	if body is entity:
		if body.picked_up_powerup == "double_damage":
			is_doing_double_damage = true
			
			body.picked_up_powerup = ""
			
	if is_doing_double_damage == true:
		double_damage_timer -= delta
		shoot_state_timer = powerup_damage_rate_of_fire
		body.bullets_left = body.max_bullets
		if double_damage_timer <= 0.0:
			double_damage_timer = double_damage_time_duration
			is_doing_double_damage = false
			shoot_state_timer = go_to_shoot_state_timer
	
	attack_windup_timer -= delta
	
	if attack_windup_timer <= 0.0:
		
		if body is entity:
			var equipped_weapon = body.held_weapon.weapon_instance
			
			if equipped_weapon.get_weapon_states() == equipped_weapon.weapon_states.RELOADING:
				return
			
			equipped_weapon.set_weapon_states(equipped_weapon.weapon_states.ATTACKING)
		
		Transitioned.emit(self, "move")
