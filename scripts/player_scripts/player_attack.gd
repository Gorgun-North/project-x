extends Node

@export var body: CharacterBody2D

@export var player_hitbox_size: float = 70.0

var bullet_spawn_point_multiplier: float = 1.2

@export var rate_of_fire: float = 1.0
@export var attack_cooldown_timer: Timer

func _ready() -> void:
	attack_cooldown_timer.wait_time = rate_of_fire

func _process(delta: float) -> void:
	
	if !attack_cooldown_timer.is_stopped():
		return
	
	if Input.is_action_just_pressed("LMB"):
		
		if body:
			if attack_cooldown_timer.is_stopped():
				attack_cooldown_timer.start()
			var bullet = preload("res://scenes/object_scenes/bullet.tscn").instantiate()
			
			var mouse_pos := body.get_global_mouse_position()
			var shoot_angle : float = (mouse_pos - body.global_position).angle()
			
			var bullet_dir: Vector2 = (mouse_pos - body.global_position).normalized()
			
			var bullet_spawn_distance : float = player_hitbox_size * bullet_spawn_point_multiplier
			bullet.global_position = body.global_position + bullet_dir * bullet_spawn_distance
			
			
			bullet.rotation = shoot_angle
			
			get_tree().root.add_child(bullet)
			
		else:
			print("body is not selected, attach it to this node: ", self)
