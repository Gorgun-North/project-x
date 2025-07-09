extends entity
@export var explosion_radius: Area2D
@export var barrel_damage: float = 30.0
@export var knockback_force: float = 2000.0
@export var knockback_duration: float = 0.3
	
func actions_before_death() -> void:
	if health <= 0.0:
		
		for i in explosion_radius.get_overlapping_bodies():
			if i is entity:
				var dir = -(self.global_position - i.global_position)
				i.take_damage(barrel_damage)
				i.got_hit.emit(dir, knockback_force, knockback_duration)
				
		self.queue_free()
	
