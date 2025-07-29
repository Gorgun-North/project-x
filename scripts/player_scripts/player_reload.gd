extends Node
class_name player_reload

@export var body: entity
var player_reloads_bullet: bool = false
var reload_timer: float


func reload_gun():
	#print(equipped_weapon.get_bullets_left())
	var equipped_weapon = body.held_weapon.weapon_instance
	
	if !equipped_weapon:
		return
		
	if equipped_weapon.get_weapon_states() == equipped_weapon.weapon_states.RELOADING:
		player_reloads_bullet = true
	else:
		player_reloads_bullet = false
		
	if equipped_weapon.get_bullets_left() >= body.held_weapon.max_bullets:
		return

	if Input.is_action_pressed("RELOAD_BUTTON"):
		
		if equipped_weapon.get_weapon_states() == equipped_weapon.weapon_states.ATTACKING:
			return
		
		equipped_weapon.set_weapon_states(equipped_weapon.weapon_states.RELOADING)
		
		
		
func _process(_delta: float) -> void:
	if body.picked_up_powerup == "double_damage":
		pass
	
	reload_gun()
