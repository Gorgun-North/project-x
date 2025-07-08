extends states
class_name player_knockback

@export var entity_instance: entity
@export var state_machine_controller_instance: state_machine_controller

@export var knockback: float = 800.0
@export var knockback_duration: float = 0.3

var knockback_timer: float = 0.0

func _ready() -> void:
	if entity_instance:
		entity_instance.got_hit.connect(_on_player_got_hit)
		
func Entered() -> void:
	knockback_timer = knockback_duration
		
func Physics_Update(delta) -> void:
	knockback_timer -= delta
	
	if knockback_timer <= 0.0:
		Transitioned.emit(self, "Idle")
	

func _on_player_got_hit(hit_direction: Vector2) -> void:
	if state_machine_controller_instance:
		Transitioned.emit(state_machine_controller_instance.current_state, "Knockback")
		
		entity_instance.velocity = hit_direction.normalized() * knockback
		#var calc_angle = (entity_instance.global_position - hit_direction).normalized()
		#entity_instance.velocity = calc_angle * knockback
