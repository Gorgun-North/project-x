extends Node

@export var entity_instance: entity

@export var knockback: float = 800.0

func _ready() -> void:
	if entity_instance:
		self.entity_instance.got_hit.connect(_register_knockback)
	
func _register_knockback(hit_direction: Vector2):
	if !entity_instance:
		return
		
	if !hit_direction:
		return
		
	var calc_angle = (entity_instance.global_position - hit_direction).normalized()
	entity_instance.velocity = calc_angle * knockback
	entity_instance.move_and_slide()
