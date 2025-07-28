extends weapon
class_name lever_action_rifle

@export var weapon_instance: weapon

func handle_ui():
	if weapon_instance.is_reloading_flag == true:
		return
	
	for i in range(weapon_instance.max_bullets):
		if i >= weapon_instance.bullets_left:
			
			if bullet_UI_elements[i].bullet_full == false:
				continue
			
			bullet_UI_elements[i].anim_player.play("shoot_bullet")
			bullet_UI_elements[i].bullet_full = false

func handle_ui_reload() -> void:
	if weapon_instance.is_reloading_flag == true:
		var ui_bullethole_instance = bullet_UI_elements[weapon_instance.bullets_left]
		
		if ui_bullethole_instance.bullet_full == false:
			print(ui_bullethole_instance.bullet_full)
			ui_bullethole_instance.bullet_full = true
			ui_bullethole_instance.anim_player.play("reload_bullet")
	
func reload_lever_action_shotgun() -> void:
	if weapon_instance.is_reloading_flag == true:
		weapon_instance.reload_timer -= get_process_delta_time()
		
		if weapon_instance.reload_timer <= 0.0:
			weapon_instance.is_reloading_flag = false
			weapon_instance.reload_timer = weapon_instance.reload_time
			weapon_instance.bullets_left += 1

func _spawn_bullet_decal() -> void:
	var bullet_decal_object = preload("res://scenes/misc_scenes/bullet_decal.tscn").instantiate()
	bullet_decal_object.global_position = weapon_instance.global_position
	bullet_decal_object.global_rotation = weapon_instance.global_rotation
	get_tree().root.add_child(bullet_decal_object)

func spawn_bullet() -> void:
	var bullet_instance = preload("res://scenes/object_scenes/bullet.tscn").instantiate()
	var shoot_angle : float
			
	#if input_mode.mouse_look_mode == "mouse":
	var mouse_pos := self.get_global_mouse_position()
	shoot_angle = (mouse_pos - weapon_instance.bullet_spawn_marker.global_position).angle()
	#elif input_mode.mouse_look_mode == "controller": 
		#shoot_angle = (aim_ray.get_collision_point()- body.global_position).angle()

	if weapon_instance.wielder_of_weapon is entity:
		bullet_instance.setup(bullet_spawn_marker.get_collision_point(), weapon_instance.wielder_of_weapon)
	
	bullet_instance.global_position = bullet_spawn_marker.global_transform.origin
	bullet_instance.rotation = shoot_angle
	gun_soundplayer.play(0.0)
	
	weapon_instance.bullets_left -= 1
	_spawn_bullet_decal()
	get_tree().root.add_child(bullet_instance)
	
func _process(_delta: float) -> void:
	reload_lever_action_shotgun()
	
	if weapon_instance.is_attacking_flag == true:
		
		spawn_bullet()
