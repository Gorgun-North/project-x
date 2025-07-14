extends states
class_name enemy_pickup_powerup

const TELEPORT_ABILITY_LEVEL_UNLOCK: int = 2

@export var go_pickup_powerup_random_chance: float = 0.25
@export var state_machine_controller_instance: state_machine_controller
@export var nav: NavigationAgent2D

var rng = RandomNumberGenerator.new()

func Entered() -> void:
	var powerups = get_tree().get_nodes_in_group("powerup")
	var all_powerups_in_lvl = get_tree().get_node_count_in_group("powerup")
	
	var get_random_powerup_number: int = rng.randi_range(0, all_powerups_in_lvl - 1)
	
	var desired_powerup = powerups[get_random_powerup_number]
	
	if nav:
		nav.set_target_position(desired_powerup.global_position)

func _Physics_Update(_delta) -> void:
	DIT MOET NOG AF

func _on_timer_timeout() -> void:
	var random_die = rng.randf_range(0.0, 1.0)
	print(random_die)
	
	if random_die <= go_pickup_powerup_random_chance:
		
		
		if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("dodge"):
			return
			
		Transitioned.emit(state_machine_controller_instance.current_state, "pickup_powerup")
