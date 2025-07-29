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
	player = get_tree().get_first_node_in_group("Player")
	enemy = get_tree().get_first_node_in_group("Enemy")
	
	
	player_healthbar.max_value = player.max_health
	
	await get_tree().process_frame
	player.held_weapon.connect("ui_bullet_fired", _on_bullet_fired)
	player.held_weapon.connect("ui_bullet_reloaded", _on_bullet_reloaded)
	player.held_weapon.connect("initiate_bullet_ui", _on_initiate_bullet_ui)


func _process(_delta: float) -> void:

	
	if Dialogic.VAR.is_paused == true:
		$Control.visible = false
	else:
		$Control.visible = true
	
	if player:
		if !player.held_weapon:
			return
		
		player_healthbar.value = player.health
	if enemy:
		enemy_healthbar.value = enemy.health
	if get_tree().paused:
		self.hide()
	elif player.health <= 0.0:
		self.hide()
	else:
		self.show()
			
func _on_bullet_fired(index: int):
	var bullet_object: bullet_UI = bullet_UI_element_array[index]
	if bullet_object.bullet_full:
		bullet_object.bullet_full = false
		bullet_object.anim_player.play("shoot_bullet")
		
func _on_bullet_reloaded(index: int, reload_amount: int):
	await _play_reload_animation_sequence(reload_amount)

func _play_reload_animation_sequence(amount: int) -> void:
	var reloaded = 0
	for i in range(bullet_UI_element_array.size()):
		if reloaded >= amount:
			break

		var bullet_object: bullet_UI = bullet_UI_element_array[i]
		if !bullet_object.bullet_full:
			bullet_object.bullet_full = true
			bullet_object.anim_player.play("reload_bullet")
			reloaded += 1
			await get_tree().create_timer(0.5).timeout  # Adjust as needed
		
func _on_initiate_bullet_ui(bullet_amount: int) -> void:
	var bullet_UI_scene = preload("res://scenes/UI_scenes/bullet_ui_element.tscn")
	
	for i in bullet_amount:
		var bullet_UI_instance = bullet_UI_scene.instantiate()
		remaining_bullets_UI.add_child(bullet_UI_instance)
		bullet_UI_element_array.append(bullet_UI_instance)
	
