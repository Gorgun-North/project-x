extends Node2D
class_name weapon

signal ui_bullet_fired(index: int)
signal ui_bullet_reloaded(index: int)
signal initiate_bullet_ui(clip_amount: int)

@onready var weapon_sprite: Sprite2D = $weapon_sprite
@onready var aim_raycast: RayCast2D = $weapon_sprite/RayCast2D
@onready var reload_ui_interface: Node2D = $reload_ui_timer_placeholder
@onready var reload_bar: TextureProgressBar = $reload_ui_timer_placeholder/Control/VBoxContainer/ProgressBar
@onready var gun_reload_sound: AudioStreamPlayer2D = $reload_ui_timer_placeholder/AudioStreamPlayer2D

@export var anim_player: AnimationPlayer
var wielder_of_weapon: entity

var is_ui_initiated_flag: bool = false

@export var flip_left_pos: Vector2
@export var flip_right_pos: Vector2

var max_bullets: int
var weapon_damage: float
var rate_of_fire: float
var reload_time: float

var reload_ui_interface_pos: Vector2

var bullets_left: int
var rate_of_fire_timer: float
var reload_timer: float

enum weapon_states {IDLE, ATTACKING, RELOADING, RESETTING}
var current_state: weapon_states = weapon_states.IDLE

func get_weapon_states() -> weapon_states:
	return current_state
	
func set_weapon_states(new_state: int) -> void:
	current_state = new_state
	
func get_bullets_left() -> int:
	return bullets_left
	
func set_bullets_left(new_amount) -> void:
	bullets_left = new_amount

func _setup(max_bullets_setup: int, weapon_damge_setup: float, rate_of_fire_setup: float, reload_time_setup: float, wielder_of_weapon_setup: entity) -> void:
	max_bullets = max_bullets_setup
	bullets_left = max_bullets_setup
	weapon_damage = weapon_damge_setup
	rate_of_fire = rate_of_fire_setup
	reload_time = reload_time_setup
	reload_timer = reload_time_setup
	wielder_of_weapon = wielder_of_weapon_setup
	reload_bar.max_value = reload_time
	reload_bar.min_value = 0.0
	reload_bar.value = reload_time

func spawn_bullet(bullet_scene_path: String, decal_scene_path: String) -> void:
	
	var bullet_scene := load(bullet_scene_path)
	if bullet_scene == null:
		push_error("Could not load bullet scene: " + bullet_scene_path)
		return
	
	var bullet_instance = bullet_scene.instantiate()
	var shoot_angle: float

	if wielder_of_weapon.name.begins_with("Player"):
		var mouse_pos := self.get_global_mouse_position()
		shoot_angle = (mouse_pos - aim_raycast.global_position).angle()
	elif wielder_of_weapon.name.begins_with("Enemy"):
		var player_node := get_tree().get_first_node_in_group("Player")
		var player_pos: Vector2 = player_node.global_position
		var target_pos: Vector2 = aim_raycast.to_global(aim_raycast.target_position)
		shoot_angle = (player_pos - target_pos).angle() + PI

	if wielder_of_weapon is entity:
		bullet_instance.setup(aim_raycast.get_collision_point(), wielder_of_weapon)
	
	bullet_instance.global_position = aim_raycast.global_transform.origin
	bullet_instance.rotation =  shoot_angle 
	if bullets_left > 0 and get_tree().paused == false and wielder_of_weapon.health > 0.0:
		
		$gunsound.play(0.0)
		
		if wielder_of_weapon.name.begins_with("Player"):
			emit_signal("ui_bullet_fired", bullets_left - 1)
			
		bullets_left -= 1
		spawn_bullet_decal(decal_scene_path)
		bullet_instance.name = "Bullet_decal_instance"  # or any naming logic you like
		get_tree().root.add_child(bullet_instance)

func spawn_bullet_decal(decal_scene_path: String) -> void:
	var scene_resource = load(decal_scene_path)
	if scene_resource == null:
		print("Error: Could not load decal scene at path:", decal_scene_path)
		return
	
	var bullet_decal_object = scene_resource.instantiate()
	bullet_decal_object.global_position = global_position
	bullet_decal_object.global_rotation = global_rotation
	get_tree().root.add_child(bullet_decal_object)

func weapon_use_for_ai():
	if !wielder_of_weapon:
		return
	if !wielder_of_weapon.name.begins_with("Enemy"):
		return
		
		
			
	var player = get_tree().get_first_node_in_group("Player")
	if !player:
		return
		
	var player_pos = player.global_position
	var direction = (player_pos - global_position).normalized()
	var angle = direction.angle()

	var aiming_left = direction.x < 0.0
	weapon_sprite.flip_h = aiming_left

	if aiming_left:
		angle += PI
		weapon_sprite.position = flip_left_pos
		aim_raycast.target_position.x = -10000
	else:
		weapon_sprite.position = flip_right_pos
		aim_raycast.target_position.x = 10000

	self.rotation = angle
	
	

func weapon_use_for_player() -> void:
	if !wielder_of_weapon.name.begins_with("Player"):
		return

	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	var angle = direction.angle()
	var gun_angle = direction.angle()

	var aiming_left = direction.x < 0.0
	weapon_sprite.flip_h = aiming_left

	# Add PI (180°) to angle if aiming left to keep gun upright
	if aiming_left:
		angle += PI
		weapon_sprite.position = flip_left_pos
		aim_raycast.target_position.x = -10000
	else:
		weapon_sprite.position = flip_right_pos
		aim_raycast.target_position.x = 10000
	self.rotation = angle

func check_rate_of_fire() -> void:
	if current_state == weapon_states.RESETTING:
		
		rate_of_fire_timer -= get_process_delta_time()
		if rate_of_fire_timer <= 0.0:
			rate_of_fire_timer = rate_of_fire
			current_state = weapon_states.IDLE
		
		

func fire_gun() -> void:
	if bullets_left < 0:
		return 
	
	#If the entity is not attacking, dont do anything
	if current_state != weapon_states.ATTACKING:
		return
	
	rate_of_fire_timer = rate_of_fire
	current_state = weapon_states.RESETTING
	
	anim_player.stop()
	anim_player.play("gun_fire")
	await anim_player.animation_finished
	anim_player.play("gun_idle")


func _ready() -> void:
	anim_player.play("gun_idle")
	reload_bar.visible = false

func _process(_delta: float) -> void:
	if !wielder_of_weapon:
		return
	
	if is_ui_initiated_flag == false:
		
		if wielder_of_weapon.name.begins_with("Player"):
			initiate_bullet_ui.emit(max_bullets)
			is_ui_initiated_flag = true
		
	check_rate_of_fire()
	fire_gun()

func _physics_process(_delta: float) -> void:
	if !weapon_sprite:
		return
		
	if !wielder_of_weapon:
		return
		
	reload_ui_interface.global_position = wielder_of_weapon.global_position + reload_ui_interface_pos
	
	weapon_use_for_ai()
	weapon_use_for_player()
	
