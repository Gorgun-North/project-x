extends Node
class_name enemy_reload

@export var state_machine_controller_instance: state_machine_controller
@export var body: entity
var bool_for_printline: bool = false
	
func _process(delta: float) -> void:
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("melee_attack"):
		return

	if bool_for_printline == false:
		print("NEED TO RELOAD!")
		bool_for_printline = true

	var equipped_weapon = body.held_weapon.weapon_instance
	
	if equipped_weapon.get_bullets_left() <= 0:
		equipped_weapon.set_weapon_states(equipped_weapon.weapon_states.RELOADING)
	
