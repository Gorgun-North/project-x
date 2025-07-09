extends Area2D
class_name bullet

@export var bullet_speed: float = 500.0

var dir: Vector2
var knockback_force: float = 400.0
var knockback_duration_player: float = 0.3
var knockback_duration_enemy: float = 0.15

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
			print(i)
			if i is entity:
				targetbody = i
				
				targetbody.take_damage(bullet_damage)
				if targetbody.name.begins_with("Player"):
					targetbody.got_hit.emit(dir, knockback_force, knockback_duration_player)
				elif targetbody.name.begins_with("Enemy"):
					targetbody.got_hit.emit(dir, knockback_force, knockback_duration_enemy)
				else:
					targetbody.got_hit.emit(dir, knockback_force, knockback_duration_player)
					
		self.queue_free()
