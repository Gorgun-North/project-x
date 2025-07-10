extends Node

#This shit dont work yet

@export var invulnerability_timer_start_value: float = 1.0
@export var body: CharacterBody2D
@export var state_machine_controller_instance: state_machine_controller


var track_health: float
var keep_HP: float
var invulnerability_timer: float

func _ready() -> void:
	track_health = body.health
	invulnerability_timer = invulnerability_timer_start_value

func _process(delta: float) -> void:
	if body.health != track_health:
		invulnerability_timer -= delta
		
		
		state_machine_controller_instance.Transitioned.emit(state_machine_controller_instance.current_state, 
		state_machine_controller_instance.states_dict.get("move")
		)
		
		if invulnerability_timer <= delta:
			pass
		
	
			
		
		
