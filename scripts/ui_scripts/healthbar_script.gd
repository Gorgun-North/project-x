extends Control

var player: entity
var enemy: entity

@export var player_healthbar: ProgressBar
@export var enemy_healthbar : ProgressBar
@export var remaining_bullets_UI: HBoxContainer

var bullet_UI_element_array: Array = []
var new_bullet_amount: int

func _ready() -> void:
	var bullet_UI_scene = preload("res://scenes/UI_scenes/bullet_ui_element.tscn")
	
	player = get_tree().get_first_node_in_group("Player")
	enemy = get_tree().get_first_node_in_group("Enemy")
	
	call_deferred("set_bullet_amount")
	
	if player is entity:
		for i in player.max_bullets:
			var bullet_UI_instance = bullet_UI_scene.instantiate()
			remaining_bullets_UI.add_child(bullet_UI_instance)
			bullet_UI_element_array.append(bullet_UI_instance)
	
	
	if player:
		player_healthbar.max_value = player.health
	if enemy:
		enemy_healthbar.max_value = enemy.health

func set_bullet_amount():
	new_bullet_amount = player.bullets_left


func set_bullet_ui():
	if player is entity:
		for i in range(player.max_bullets):
			if i < player.bullets_left:
				bullet_UI_element_array[i].set_bullet_frame(0)  # Full
			else:
				bullet_UI_element_array[i].set_bullet_frame(1)  # Empty
			
			
			

func _process(_delta: float) -> void:
	if player:
		set_bullet_ui()
		
		player_healthbar.value = player.health
		if player.health <= 0.0:
			self.hide()
	if enemy:
		enemy_healthbar.value = enemy.health
	if get_tree().paused:
		self.hide()
	else:
		self.show()
	
