extends Area2D
class_name bullet

@export var bullet_speed: float = 500.0

var dir: Vector2

var target: Vector2
var targetbody: entity

@export var bullet_damage: int = 25

func setup(set_target: Vector2, set_targetbody: entity) -> void:
	target = set_target
	targetbody = set_targetbody

func _ready() -> void:
	if target != null:
		dir = (target - self.global_position).normalized()
	else:
		push_error("No target set for bullet, call setup function!")

func _physics_process(delta: float) -> void:
	position += dir * bullet_speed * delta
	
	
	if self.has_overlapping_bodies():
		for i in self.get_overlapping_bodies():
			if i == targetbody:
				targetbody.take_damage(bullet_damage)
				print(targetbody, ": ", targetbody.health)
				
		if targetbody.name.begins_with("Player"):
			if targetbody.health == 0:
				get_tree().quit()
		
		self.queue_free()
