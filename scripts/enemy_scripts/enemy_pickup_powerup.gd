extends states
class_name enemy_pickup_powerup

const TELEPORT_ABILITY_LEVEL_UNLOCK: int = 2

@export var go_pickup_powerup_random_chance: float = 0.25
@export var state_machine_controller_instance: state_machine_controller
@export var nav: NavigationAgent2D
@export var powerup_timer: Timer
var is_powerup_picked_up: bool = true

var rng = RandomNumberGenerator.new() 
var desired_powerup: Node2D

func Entered() -> void:
	if body.picked_up_powerup != "":
		Transitioned.emit(self, "idle")
		
	print("Nu ga ik een powerup oppakken")
		
	var powerups = get_tree().get_nodes_in_group("powerup")
	var all_powerups_in_lvl = get_tree().get_node_count_in_group("powerup")
	
	var get_random_powerup_number: int = rng.randi_range(0, all_powerups_in_lvl - 1)
	
	if desired_powerup == null:
		desired_powerup = powerups[get_random_powerup_number]
	
	if desired_powerup.name.begins_with("health"):
		if body.health >= body.max_health:
			return
	
	if nav:
		is_powerup_picked_up = false
		nav.set_target_position(desired_powerup.global_position)
		
	if !nav.target_reached.is_connected(_on_target_reached):
		nav.target_reached.connect(_on_target_reached)

func Physics_Update(_delta) -> void:
	if !desired_powerup:
		push_error("No valid powerup given")
		Transitioned.emit(self, "idle")
		
	
	var steer_target: Vector2 = nav.get_next_path_position()
	body.look_at(nav.get_next_path_position())
	var dir: Vector2 = (steer_target - body.global_position).normalized()
	
	body.velocity = dir * body.speed

func _on_timer_timeout() -> void:
	var random_die = rng.randf_range(0.0, 1.0)
	print(random_die)
	
	if random_die <= go_pickup_powerup_random_chance:
		
		
		if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("dodge") \
		or state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("pickup_powerup"):
			return
			
		if body.picked_up_powerup != "":
			return
		
		
		Transitioned.emit(state_machine_controller_instance.current_state, "pickup_powerup")

func _physics_process(_delta: float) -> void:
	if is_powerup_picked_up == false:
		if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("move"):
			state_machine_controller_instance.current_state = state_machine_controller_instance.states_dict.get("pickup_powerup")
		body.set_collision_layer_value(2, true)
	else:
		body.set_collision_layer_value(2, false)
		

func _on_target_reached():
	if body is not entity:
		push_error("Body is not entity???")
		
	is_powerup_picked_up = true
	desired_powerup = null
		
	if body.picked_up_powerup == "speed":
		Transitioned.emit(self, "Move")
