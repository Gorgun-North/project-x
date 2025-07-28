extends Node
class_name player_reload

@export var body: entity
@export var reload_bar: ProgressBar
@export var held_weapon: weapon
var player_reloads_bullet: bool = false
var reload_timer: float

func _ready() -> void:
	if held_weapon:
		reload_timer = held_weapon.reload_time
		reload_bar.min_value = 0.0
		reload_bar.max_value = held_weapon.reload_time
		reload_bar.value = held_weapon.reload_time
		reload_bar.visible = false

func reloaded() -> void:
		
		reload_timer = held_weapon.reload_time
		player_reloads_bullet = false
		reload_bar.visible = false
		reload_bar.value = held_weapon.reload_time

func reload_gun():
	
	if held_weapon:
		if held_weapon.bullets_left >= held_weapon.max_bullets:
			return
	
		if Input.is_action_pressed("RELOAD_BUTTON"):
			player_reloads_bullet = true
		
		if player_reloads_bullet == true:
			held_weapon.is_reloading_flag = true
			reload_timer -= get_process_delta_time()
			reload_bar.value = reload_timer
			reload_bar.visible = true
			
			if reload_timer <= 0.0:
				reloaded()
		
func _process(_delta: float) -> void:
	if body.picked_up_powerup == "double_damage":
		reloaded()
	
	reload_gun()
