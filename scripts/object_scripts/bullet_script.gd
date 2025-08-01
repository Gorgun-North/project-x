extends Area2D
class_name bullet

@export var bullet_speed: float = 500.0

var dir: Vector2
var knockback_force: float = 400.0
var knockback_duration_player: float = 0.3
var knockback_duration_enemy: float = 0.15

var attacker: entity
var target: Vector2
var targetbody: entity

var hit_entity_flag: bool = false

@export var bullet_damage: int = 10

func setup(set_target: Vector2, set_attacker: entity) -> void:
	attacker = set_attacker
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
			if i is entity:
				
				if i == attacker:
					return
					
				if hit_entity_flag == false:
					hit_entity_flag = true
				targetbody = i
				
				targetbody.take_damage(bullet_damage)
				if targetbody.name.begins_with("Player"):
					
					targetbody.got_hit.emit(attacker, dir, knockback_force, knockback_duration_player)
				elif targetbody.name.begins_with("Enemy"):
					
					targetbody.got_hit.emit(attacker, dir, knockback_force, knockback_duration_enemy)
				else:
					targetbody.got_hit.emit(attacker, dir, knockback_force, knockback_duration_player)
					
		

		self.queue_free()

func _on_tree_exiting() -> void:
	if hit_entity_flag == true:
		return
	
	var bullethole_instance = preload("res://scenes/misc_scenes/bullethole.tscn").instantiate()
	bullethole_instance.rotation = -self.rotation
	bullethole_instance.global_position = self.global_position
	bullethole_instance.z_index = 1000
	
	get_tree().current_scene.add_child(bullethole_instance)
