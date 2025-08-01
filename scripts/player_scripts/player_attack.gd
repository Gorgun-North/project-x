extends Node

@export var body: CharacterBody2D
@export var player_reload_instance: player_reload


@export var player_hitbox_size: float = 70.0

var bullet_spawn_point_multiplier: float = 1.2

@export var rate_of_fire: float = 1.0
@export var attack_cooldown_timer: Timer
@export var input_mode: mouse_look

func _process(delta: float) -> void:
	
	var equipped_weapon = body.held_weapon.weapon_instance
	
	if body.health <= 0.0:
		return
	
	if Dialogic.VAR.is_paused == true:
		return

	if player_reload_instance.player_reloads_bullet == true:
		return
		
	if equipped_weapon.get_weapon_states() == equipped_weapon.weapon_states.RESETTING:
		return
	
	if Input.is_action_just_pressed("LMB"):
		
		if body is entity:
			if body.invulnerable == true:
				return
			
				
			equipped_weapon.set_weapon_states(equipped_weapon.weapon_states.ATTACKING)
			
		else:
			print("body is not selected, attach it to this node: ", self)
