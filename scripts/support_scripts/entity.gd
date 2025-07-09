extends CharacterBody2D
class_name entity

signal got_hit(hit_direction: Vector2, knockback_force: float, knockback_duration: float)

@export var health: int = 100

func actions_before_death() -> void:
	pass

func take_damage(damage: int):
	health -= damage

func _process(_delta: float) -> void:
	actions_before_death() 
	
	if !self.name.begins_with("Player"):
		if health == 0:
			self.queue_free()
