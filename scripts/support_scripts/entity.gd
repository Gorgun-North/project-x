extends CharacterBody2D
class_name entity

signal got_hit(hit_direction: Vector2, knockback_force: float, knockback_duration: float)

@export var health: int = 100
@export var navobstacle: NavigationObstacle2D

func actions_before_death() -> void:
	pass
	
func rebake_on_movement():
	var root = get_tree().current_scene
	
	if root is game_controller:
		root.bake_navmesh.emit()

func take_damage(damage: int):
	health -= damage

func _process(_delta: float) -> void:
	actions_before_death() 
	
	
	if !self.name.begins_with("Player"):
		if health <= 0.0:
			self.queue_free()
			
