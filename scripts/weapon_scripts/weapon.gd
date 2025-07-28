extends Node2D
class_name weapon

@export var anim_player: AnimationPlayer
@export var sprite2D   : Sprite2D
@export var bullet_spawn_marker: RayCast2D
@export var gun_soundplayer: AudioStreamPlayer2D
@export var wielder_of_weapon: entity

@export var correct_gun_rotation_left: float = 45
@export var correct_gun_rotation_right: float = 135

@export var max_bullets: int = 6
@export var weapon_damage: float = 10.0
@export var rate_of_fire: float = 0.5
@export var reload_time: float = 2.4

var bullets_left: int
var rate_of_fire_timer: float
var reload_timer: float

var is_attacking_flag: bool = false
var reset_aim_flag: bool 
var is_reloading_flag: bool

var bullet_UI_elements: Array = []

func initiate_bullet_UI(parent: Control) -> void:
	var bullet_UI_scene = preload("res://scenes/UI_scenes/bullet_ui_element.tscn")
	
	if is_attacking_flag == true:
		return
	
	for j in max_bullets:
		var bullet_UI_instance = bullet_UI_scene.instantiate()
		parent.add_child(bullet_UI_instance)
		bullet_UI_elements.append(bullet_UI_instance)

func check_rate_of_fire() -> void:
	if reset_aim_flag == true:
		
		rate_of_fire_timer -= get_process_delta_time()
		if rate_of_fire_timer <= 0.0:
			rate_of_fire_timer = rate_of_fire
			reset_aim_flag = false

func fire_gun() -> void:
	#If the entity is not attacking, dont do anything
	if is_attacking_flag == false:
		return
	is_attacking_flag = false
	
	#If the entity tries to attack while resetting aim (ROF), dont do anything
	if reset_aim_flag == true:
		return
	reset_aim_flag = true
	
	anim_player.stop()
	anim_player.play("gun_fire")
	await anim_player.animation_finished
	anim_player.play("gun_idle")

func _ready() -> void:
	bullets_left = max_bullets
	rate_of_fire_timer = rate_of_fire
	reload_timer = reload_time
	
	if wielder_of_weapon is entity:
		wielder_of_weapon.connect("is_attacking", _on_attack)
	anim_player.play("gun_idle")

func _process(_delta: float) -> void:
	check_rate_of_fire()
	fire_gun()

func _physics_process(_delta: float) -> void:
	var mouse_dir = get_global_mouse_position() - self.global_position
	look_at(get_global_mouse_position())

	if mouse_dir.x < 0.0:
		sprite2D.rotation = deg_to_rad(correct_gun_rotation_right)
		bullet_spawn_marker.rotation = deg_to_rad(-correct_gun_rotation_left)
		sprite2D.flip_h = false
	elif mouse_dir.x >= 0.0:
		sprite2D.flip_h = true
		sprite2D.rotation = deg_to_rad(correct_gun_rotation_left)
		bullet_spawn_marker.rotation = deg_to_rad(correct_gun_rotation_left)
	
		
func _on_attack():
	if bullets_left <= 0:
		return 
		
	if is_reloading_flag == true:
		return
		
	if reset_aim_flag == true:
		return
	
	is_attacking_flag = true
	
