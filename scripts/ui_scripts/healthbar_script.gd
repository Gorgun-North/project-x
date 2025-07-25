extends Control

var player: entity
var enemy: entity

@export var player_healthbar: TextureProgressBar
@export var enemy_healthbar : TextureProgressBar
@export var remaining_bullets_UI: HBoxContainer

var player_reload_time: float
var is_player_reloading: bool
var get_bullet_amount: int

var bullet_UI_element_array: Array = []

func _ready() -> void:
	
	var bullet_UI_scene = preload("res://scenes/UI_scenes/bullet_ui_element.tscn")
	
	player = get_tree().get_first_node_in_group("Player")
	player_reload_time = player.get_node("Reload").reload_time
	enemy = get_tree().get_first_node_in_group("Enemy")
	
	call_deferred("set_bullet_amount")
	
	if player is entity:
		get_bullet_amount = player.bullets_left
		
		for i in player.max_bullets:
			var bullet_UI_instance = bullet_UI_scene.instantiate()
			remaining_bullets_UI.add_child(bullet_UI_instance)
			bullet_UI_element_array.append(bullet_UI_instance)
	
	
	if player:
		player_healthbar.max_value = player.health
	if enemy:
		enemy_healthbar.max_value = enemy.health

func set_bullet_ui():
	if player is entity:
		
		if is_player_reloading == true:
			return
		
		for i in range(player.max_bullets):
			if i >= player.bullets_left:
				if bullet_UI_element_array[i].is_bullet_loaded == true:
					bullet_UI_element_array[i].play_bullet_ui_animation(true)
					bullet_UI_element_array[i].set_bullet_frame(0)  # Empty
			

func handle_player_reload() -> void:
	is_player_reloading = player.get_node("Reload").player_reloads_bullet
	
	if player is entity:
		var empty_bullets = player.max_bullets - player.bullets_left
		
		if is_player_reloading == true:
			for i in range(empty_bullets):  
				var get_empty_chamber = i + player.bullets_left
				
				if get_empty_chamber > player.max_bullets:
					return
				
				if bullet_UI_element_array[get_empty_chamber].is_bullet_loaded == false:
					bullet_UI_element_array[get_empty_chamber].play_bullet_ui_animation(false)
					await bullet_UI_element_array[get_empty_chamber].anim_player.animation_finished
				else:
					bullet_UI_element_array[get_empty_chamber].set_bullet_frame(4) # Full
					return
				

func _process(_delta: float) -> void:

	
	if Dialogic.VAR.is_paused == true:
		$Control.visible = false
	else:
		$Control.visible = true
	
	if player:
		
		handle_player_reload()
		set_bullet_ui()
		
		player_healthbar.value = player.health
	if enemy:
		enemy_healthbar.value = enemy.health
	if get_tree().paused:
		self.hide()
	elif player.health <= 0.0:
		self.hide()
	else:
		self.show()
			
	
