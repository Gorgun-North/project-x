extends Node

@export var body: CharacterBody2D
@export var aim_ray: RayCast2D
@export var player_reload_instance: player_reload


@export var player_hitbox_size: float = 70.0

var bullet_spawn_point_multiplier: float = 1.2

@export var rate_of_fire: float = 1.0
@export var double_damage_time_duration: float = 5.0
@export var powerup_damage_rate_of_fire: float = 0.25
@export var attack_cooldown_timer: Timer
@export var input_mode: mouse_look
@export var gunshot_sound: AudioStreamPlayer2D

var double_damage_timer: float
var is_doing_double_damage: bool = false

signal is_attacking()

func _ready() -> void:
	double_damage_timer = double_damage_time_duration
	attack_cooldown_timer.wait_time = rate_of_fire

func _physics_process(delta: float) -> void:
	
	if !body.held_weapon:
		push_error("Cant find suitable point to aim from, is a gun equipped?")
		return
	
	var aim_point = body.held_weapon.bullet_spawn_marker
	
		
	aim_ray.global_position = aim_point.global_position
	
	var mouse_dir = aim_ray.get_global_mouse_position() - aim_ray.global_position
	aim_ray.rotation = mouse_dir.angle()
	
	
	if body.health <= 0.0:
		return
	
	if Dialogic.VAR.is_paused == true:
		return
	
	if body is entity:
		if body.picked_up_powerup == "double_damage":
			is_doing_double_damage = true
			body.picked_up_powerup = ""
			
	if is_doing_double_damage == true:
		body.bullets_left = body.max_bullets
		double_damage_timer -= delta
		attack_cooldown_timer.wait_time = powerup_damage_rate_of_fire
		if double_damage_timer <= 0.0:
			double_damage_timer = double_damage_time_duration
			is_doing_double_damage = false
			attack_cooldown_timer.wait_time = rate_of_fire
			
	if player_reload_instance.player_reloads_bullet == true:
		return
		
	if body.bullets_left <= 0:
		return
	
	
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
			
		
			
			body.bullets_left -= 1
			var bullet_decal_object = preload("res://scenes/misc_scenes/bullet_decal.tscn").instantiate()
			bullet_decal_object.global_position = body.global_position
			bullet_decal_object.global_rotation = body.global_rotation
			get_tree().root.add_child(bullet_decal_object)
			gunshot_sound.play(0.0)
			get_tree().root.add_child(bullet_instance)
			
			is_attacking.emit()
			
		else:
			print("body is not selected, attach it to this node: ", self)
