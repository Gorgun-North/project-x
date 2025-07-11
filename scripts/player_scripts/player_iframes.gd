extends states

#This shit dont work yet

@export var state_machine_controller_instance: state_machine_controller
@export var entity_instance: entity
@export var knockback_instance: player_knockback
@export var animplayer: AnimationPlayer


var invulnerability_timer_start_value: float
var track_health: float
var invulnerability_timer: float
var invulnerability_hp: float = 0.0
var invulnerability_changed: bool = false

func turn_player_invulnerable(object: entity):
	
	if animplayer and object.invulnerable == true:
		if animplayer.current_animation != "Iframes":
			animplayer.play("Iframes")
			
	
	if object.invulnerable == true:
		Transitioned.emit(state_machine_controller_instance.current_state, 
		state_machine_controller_instance.states_dict.get("move")
		)
	

func turn_invulnerable(object: entity, invulnerable_time: float):
	if object.health < track_health:
	
		if invulnerability_hp == 0.0:
			invulnerability_hp = object.health
		else:
			object.health = invulnerability_hp
		
		invulnerability_timer -= get_process_delta_time()
		entity_instance.invulnerable = true

		
		if invulnerability_timer <= get_process_delta_time():
			invulnerability_timer = invulnerable_time
			invulnerability_hp = 0.0
			track_health = object.health
	else:
		track_health = object.health
		object.invulnerable = false

func _ready() -> void:
	invulnerability_timer = animplayer.get_animation("Iframes").length
	track_health = entity_instance.health

func _process(delta: float) -> void:
	if entity_instance.picked_up_powerup == "":
		turn_player_invulnerable(entity_instance)
		turn_invulnerable(entity_instance, animplayer.get_animation("Iframes").length)
	else:
		if animplayer.current_animation == "Iframes":
			animplayer.stop(true)
		entity_instance.invulnerable = false
		track_health = entity_instance.health
		#entity_instance.picked_up_powerup =  ""
		
		
