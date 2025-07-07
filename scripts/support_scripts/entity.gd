extends Node
class_name entity

var health: int = 100

func take_damage(damage: int):
	health -= damage

func _process(_delta: float) -> void:
	if health == 0:
		self.queue_free()
