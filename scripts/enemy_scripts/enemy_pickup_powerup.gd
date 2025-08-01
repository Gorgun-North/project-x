extends states
class_name enemy_pickup_powerup

const PICKUP_POWERUP_ABILITY_LEVEL_UNLOCK: int = 2

@export var state_machine_controller_instance: state_machine_controller
@export var nav: NavigationAgent2D
@export var powerup_timer: Timer

@export var go_pickup_powerup_random_chance: float = 0.25
@export var desired_distance_to_pickup_powerup: float = 50.0
@export var pickup_powerup_allowed_distance: float = 52.5
@export var walk_to_powerup_movespeed: float = 1300.0
var is_powerup_picked_up: bool = true
var health_on_entered: int

var rng = RandomNumberGenerator.new() 
var desired_powerup: Node2D
var root

func _ready() -> void:
	root = get_tree().current_scene

func Entered() -> void:
	if root.current_stage < PICKUP_POWERUP_ABILITY_LEVEL_UNLOCK:
		Transitioned.emit(self, "Idle")
	
	if body.picked_up_powerup != "":
		Transitioned.emit(self, "idle")
		
	var all_powerups_in_lvl = get_tree().get_nodes_in_group("powerup")
	
	health_on_entered = body.health
	
	#Set the closest powerup to an impossible distance so whatever powerup comes next is closer
	var closest_powerup_distance: float = 10000.0
	var chosen_powerup: Node2D
	
	
	for powerup: Node2D in all_powerups_in_lvl:
		if body.health == body.max_health and powerup.name.begins_with("health"):
			continue
		
		if powerup.global_position.distance_to(body.global_position) < closest_powerup_distance:
			closest_powerup_distance = powerup.global_position.distance_to(body.global_position)
			chosen_powerup = powerup
	
	if desired_powerup == null:
		desired_powerup = chosen_powerup

func Physics_Update(_delta) -> void:
	if health_on_entered != body.health:
		target_reached()
		Transitioned.emit(self, "idle")
	
	if !desired_powerup:
		target_reached()
		Transitioned.emit(self, "idle")
		
	if !is_instance_valid(desired_powerup):
		target_reached()
		return
		
	if nav:
		nav.set_target_position(desired_powerup.global_position)
	
	var steer_target: Vector2 = nav.get_next_path_position()
	#body.look_at(nav.get_next_path_position())
	var dir: Vector2 = (steer_target - body.global_position).normalized()
	
	body.velocity = dir * walk_to_powerup_movespeed
		
	if body.global_position.distance_to(desired_powerup.global_position) < desired_distance_to_pickup_powerup:
		target_reached()

func _on_timer_timeout() -> void:
	
	if root.current_stage < PICKUP_POWERUP_ABILITY_LEVEL_UNLOCK:
		return
	
	var random_die = rng.randf_range(0.0, 1.0)
	if random_die <= go_pickup_powerup_random_chance:
		
		
		if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("dodge") \
		or state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("pickup_powerup") \
		or state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("melee_attack"):
			return
			
		if body.picked_up_powerup != "":
			return
		
		is_powerup_picked_up = false
		print("Time to pick that shit up")
		Transitioned.emit(state_machine_controller_instance.current_state, "pickup_powerup")

func _physics_process(_delta: float) -> void:
	if root.current_stage < PICKUP_POWERUP_ABILITY_LEVEL_UNLOCK:
		return
	
	if is_powerup_picked_up == false:
		if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("move"):
			state_machine_controller_instance.current_state = state_machine_controller_instance.states_dict.get("pickup_powerup")
		
		if is_instance_valid(desired_powerup):
			if body.global_position.distance_to(desired_powerup.global_position) < pickup_powerup_allowed_distance:
				body.set_collision_layer_value(2, true)
	else:
		body.set_collision_layer_value(2, false)
		

func target_reached():
	if body is not entity:
		push_error("Body is not entity???")
	
	if state_machine_controller_instance.current_state != state_machine_controller_instance.states_dict.get("pickup_powerup"):
		return
		
		
	is_powerup_picked_up = true
	print("THIS POWER IS NOW MINE!")
	desired_powerup = null
	
	
