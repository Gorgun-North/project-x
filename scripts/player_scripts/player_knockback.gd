extends states
class_name player_knockback

@export var entity_instance: entity
@export var state_machine_controller_instance: state_machine_controller

var knockback_duration_instance: float

var knockback_timer: float = 0.0

func _ready() -> void:
	if entity_instance:
		entity_instance.got_hit.connect(_on_player_got_hit)
		
func Entered() -> void:
	
	
	knockback_timer = knockback_duration_instance
		
func Physics_Update(delta) -> void:
	knockback_timer -= delta
	
	if knockback_timer <= 0.0:
		Transitioned.emit(self, "Idle")
	

func _on_player_got_hit(hit_direction: Vector2, knockback_force: float, knockback_duration: float) -> void:
	if state_machine_controller_instance:
		knockback_duration_instance = knockback_duration
		
		entity_instance.velocity = hit_direction.normalized() * knockback_force
		Transitioned.emit(state_machine_controller_instance.current_state, "Knockback")
		#var calc_angle = (entity_instance.global_position - hit_direction).normalized()
		#entity_instance.velocity = calc_angle * knockback
