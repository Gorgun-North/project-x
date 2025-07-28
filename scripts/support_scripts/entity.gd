extends CharacterBody2D
class_name entity

signal got_hit(attacker: entity, hit_direction: Vector2, knockback_force: float, knockback_duration: float)
signal is_attacking()

@export var health: int = 100
@export var navobstacle: NavigationObstacle2D
var bullets_left = 6
var max_bullets = 6
@export var held_weapon: weapon

var invulnerable: bool = false
var picked_up_powerup: String
var max_health: int
@export var speed: float = 700.0

func _ready() -> void:
	max_health = health



func actions_before_death() -> void:
	pass
	
func rebake_on_movement():
	var root = get_tree().current_scene
	
	if root is game_controller:
		root.bake_navmesh.emit()

func take_damage(damage: int):
	if invulnerable == false:
		health -= damage

func _process(_delta: float) -> void:
	
	if self.name.begins_with("Enemy") and self.health <= 0:
		Dialogic.start("test-timeline2")
		
	
	if self.name.begins_with("Player") or self.name.begins_with("Enemy"):
		if health > max_health:
			health = max_health
		
	actions_before_death() 
	
	
	if !self.name.begins_with("Player"):
		if health <= 0.0:
			self.queue_free()
			
