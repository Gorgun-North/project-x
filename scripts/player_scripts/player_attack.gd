extends Node

@export var body: CharacterBody2D
@export var aim_ray: RayCast2D

@export var player_hitbox_size: float = 70.0

var bullet_spawn_point_multiplier: float = 1.2

@export var rate_of_fire: float = 1.0
@export var double_damage_time_duration: float = 5.0
@export var powerup_damage_rate_of_fire: float = 0.25
@export var attack_cooldown_timer: Timer
@export var input_mode: mouse_look

var double_damage_timer: float
var is_doing_double_damage: bool = false

func _ready() -> void:
	double_damage_timer = double_damage_time_duration
	attack_cooldown_timer.wait_time = rate_of_fire

func _process(delta: float) -> void:
	
	if body is entity:
		if body.picked_up_powerup == "double_damage":
			is_doing_double_damage = true
			body.picked_up_powerup = ""
			
	if is_doing_double_damage == true:
		double_damage_timer -= delta
		attack_cooldown_timer.wait_time = powerup_damage_rate_of_fire
		if double_damage_timer <= 0.0:
			double_damage_timer = double_damage_time_duration
			is_doing_double_damage = false
			attack_cooldown_timer.wait_time = rate_of_fire
			
	
	if !attack_cooldown_timer.is_stopped():
		return
	
	if Input.is_action_just_pressed("LMB"):
		
		if body is entity:
			if body.invulnerable == true:
				return
		
		if body:
			if attack_cooldown_timer.is_stopped():
				attack_cooldown_timer.start()
			var bullet_instance = preload("res://scenes/object_scenes/bullet.tscn").instantiate()
			var shoot_angle : float
			#var bullet_dir  : Vector2
			
			
			if input_mode.mouse_look_mode == "mouse":
				var mouse_pos := body.get_global_mouse_position()
				shoot_angle = (mouse_pos - body.global_position).angle()
				#bullet_dir = (mouse_pos - body.global_position).normalized()
			elif input_mode.mouse_look_mode == "controller":
				shoot_angle = (aim_ray.get_collision_point()- body.global_position).angle()
				#bullet_dir = (aim_ray.get_collision_point()- body.global_position).normalized()
		
			if body is entity:
				bullet_instance.setup(aim_ray.get_collision_point(), body)
			bullet_instance.global_position = aim_ray.global_transform.origin
			bullet_instance.rotation = shoot_angle
			
			get_tree().root.add_child(bullet_instance)
			
		else:
			print("body is not selected, attach it to this node: ", self)
