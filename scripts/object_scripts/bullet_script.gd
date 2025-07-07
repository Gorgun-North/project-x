extends Area2D
class_name bullet

@export var bullet_speed: float = 500.0

var dir: Vector2

var target: Vector2
var targetbody: entity

@export var bullet_damage: int = 10

func setup(set_target: Vector2) -> void:
	target = set_target

func _ready() -> void:
	if target != null:
		dir = (target - self.global_position).normalized()
	else:
		push_error("No target set for bullet, call setup function!")

func _physics_process(delta: float) -> void:
	position += dir * bullet_speed * delta
	
	
	if self.has_overlapping_bodies():
		for i in self.get_overlapping_bodies():
			if i.name.begins_with("Player") or i.name.begins_with("Enemy"):
				targetbody = i
				
				targetbody.take_damage(bullet_damage)
				print(targetbody, ": ", targetbody.health)
				
				if targetbody.health == 0 and targetbody.name.begins_with("Player"):
					get_tree().quit()
		
		self.queue_free()
