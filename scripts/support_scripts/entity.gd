extends CharacterBody2D
class_name entity

signal got_hit(hit_direction: Vector2)

@export var health: int = 100

func take_damage(damage: int):
	health -= damage

func _process(_delta: float) -> void:
	if !self.name.begins_with("Player"):
		if health == 0:
			self.queue_free()
