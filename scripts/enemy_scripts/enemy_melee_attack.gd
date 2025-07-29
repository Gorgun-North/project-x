extends states
class_name melee_attack

const MELEE_ATTACK_ABILITY_LEVEL_UNLOCK: int = 4

@export var state_machine_controller_instance: state_machine_controller
@export var melee_attack_hitbox_area2D: Area2D
@export var nav: NavigationAgent2D
@export var speed_powerup_timer: Timer
@export var pickup_powerup_state: enemy_pickup_powerup
@export var animplayer: AnimationPlayer


@export var melee_attack_cooldown_timer_duration: float = 15.0
@export var melee_attack_walk_speed: float = 800
@export var speed_powerup_speed: float = 1100
@export var melee_attack_windup_duration: float = 4.0
@export var melee_attack_duration: float = 10.0
@export var melee_attack_wind_down_duration: float = 4.0
@export var melee_attack_damage: float = 20.0
@export var knockback_force: float = 2000.0
@export var knockback_duration: float = 0.3
@export var needed_damage_to_stop_melee_attack: float = 20.0
@export var melee_damage_per_attack: float = 10.0
@export var accepted_distance_to_start_melee_attack: float = 1500.0

var melee_attack_temporary_hp
var melee_attack_cooldown_timer: float
var melee_attack_windup_timer: float
var melee_attack_timer: float
var melee_attack_wind_down_timer: float
var player: CharacterBody2D
var did_enemy_hit_player: bool = false
var beginning_health: float 

enum melee_attack_states {WINDUP, ATTACKING, WIND_DOWN}
var current_melee_attack_state = melee_attack_states.WINDUP
		
func Entered() -> void:
	current_melee_attack_state = melee_attack_states.WINDUP
	print("Time for a good stompin, buddy!")
	beginning_health = body.health
	
	melee_attack_temporary_hp = needed_damage_to_stop_melee_attack
	did_enemy_hit_player = false
	melee_attack_windup_timer = melee_attack_windup_duration
	melee_attack_timer = melee_attack_duration
	melee_attack_wind_down_timer = melee_attack_wind_down_duration
	

func windup() -> void:
	animplayer.play("attack_windup")
	
	if current_melee_attack_state != melee_attack_states.WINDUP:
		return
		
	melee_attack_windup_timer -= get_process_delta_time()
	body.velocity = Vector2.ZERO
	
	if melee_attack_windup_timer <= 0.0:
		current_melee_attack_state = melee_attack_states.ATTACKING
			
func attack() -> void:
	if current_melee_attack_state != melee_attack_states.ATTACKING:
		return
		
	melee_attack_timer -= get_process_delta_time()
	
	melee_attack_hitbox_area2D.monitoring = true
	nav.set_target_position(player.global_position)
	
	var steer_target: Vector2 = nav.get_next_path_position()
	#body.look_at(nav.get_next_path_position())
	var dir: Vector2 = (steer_target - body.global_position).normalized()

	if !speed_powerup_timer.is_stopped():
		body.speed = speed_powerup_speed
	else:
		body.speed = melee_attack_walk_speed
	
	body.velocity = dir * body.speed
	
	if did_enemy_hit_player == true:
		current_melee_attack_state = melee_attack_states.WIND_DOWN
		#print("COOLING DOWN: ", melee_attack_wind_down_timer)
	
	if melee_attack_hitbox_area2D.monitoring:
		for i in melee_attack_hitbox_area2D.get_overlapping_bodies():
			if i != player:
				continue

			did_enemy_hit_player = true
			i.take_damage(melee_attack_damage)

			if body is entity:
				i.got_hit.emit(body, dir, knockback_force, knockback_duration)
				
	if melee_attack_timer <= 0.0:
		if did_enemy_hit_player == false:
			current_melee_attack_state = melee_attack_states.WIND_DOWN
			
	if melee_attack_temporary_hp <= 0.0:
		current_melee_attack_state = melee_attack_states.WIND_DOWN

	
func wind_down() -> void:
	animplayer.play("attack_winddown")
	if current_melee_attack_state != melee_attack_states.WIND_DOWN:
		return
	
	body.velocity = Vector2.ZERO
	melee_attack_hitbox_area2D.monitoring = false
	melee_attack_wind_down_timer -= get_process_delta_time()
	
	if melee_attack_wind_down_timer <= 0.0:
		body.picked_up_powerup = ""
		Transitioned.emit(self, "dodge")
		
	
func Physics_Update(delta: float) -> void:
	body.health = beginning_health 
	
	windup()
	attack()
	wind_down()
	
func _ready() -> void:
	melee_attack_cooldown_timer = melee_attack_cooldown_timer_duration
	call_deferred("_ready_got_hit")
	player = get_tree().get_first_node_in_group("Player")
	
func _ready_got_hit() -> void:
	if body is entity:
		body.got_hit.connect(_on_got_hit)

func _physics_process(delta: float) -> void:
	
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("melee_attack"):
		return
	
	var root = get_tree().current_scene
	
	if root.current_stage < MELEE_ATTACK_ABILITY_LEVEL_UNLOCK:
		return
	
	if pickup_powerup_state.is_powerup_picked_up != true:
		return
		
	if body.global_position.distance_to(player.global_position) < accepted_distance_to_start_melee_attack:
	
		melee_attack_cooldown_timer -= delta
		
	if melee_attack_cooldown_timer <= 0.0:
		melee_attack_cooldown_timer = melee_attack_cooldown_timer_duration
		Transitioned.emit(state_machine_controller_instance.current_state, "melee_attack")
	
func _on_got_hit(_attacker: entity, _hit_dir: Vector2, _knockback_force: float, _knockback_dur: float):
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("melee_attack"):
		if melee_attack_windup_timer <= 0.0:
			melee_attack_temporary_hp -= melee_damage_per_attack
