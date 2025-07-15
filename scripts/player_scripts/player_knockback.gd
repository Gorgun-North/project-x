extends states
class_name player_knockback

@export var entity_instance: entity
@export var state_machine_controller_instance: state_machine_controller

var knockback_duration_instance: float
var knockback_finished: bool = true
var force: float

var knockback_dir: Vector2

var knockback_timer: float = 0.0

func _ready() -> void:
	if entity_instance:
		
		if entity_instance.got_hit.is_connected(_on_player_got_hit):
			return
		
		entity_instance.got_hit.connect(_on_player_got_hit)
		
func Entered() -> void:

	knockback_timer = knockback_duration_instance
		
func Physics_Update(delta) -> void:
	knockback_timer -= delta
	entity_instance.velocity = knockback_dir.normalized() * force
	knockback_finished = false
	
	if knockback_timer <= 0.0:
		Transitioned.emit(self, "Idle")
		
func Exit():
	knockback_finished = true
	

func _on_player_got_hit(_attacker: entity, hit_direction: Vector2, knockback_force: float, knockback_duration: float) -> void:
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("melee_attack"):
		return
	
	if state_machine_controller_instance:
		knockback_dir = hit_direction
		force = knockback_force
		
		knockback_duration_instance = knockback_duration
		
		if entity_instance.invulnerable == false:
			Transitioned.emit(state_machine_controller_instance.current_state, "Knockback")
		#var calc_angle = (entity_instance.global_position - hit_direction).normalized()
		#entity_instance.velocity = calc_angle * knockback
