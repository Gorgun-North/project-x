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
	
	if player:
		if !player.held_weapon:
			return
		player.held_weapon.initiate_bullet_UI(remaining_bullets_UI)

func _process(_delta: float) -> void:

	
	if Dialogic.VAR.is_paused == true:
		$Control.visible = false
	else:
		$Control.visible = true
	
	if player:
		if !player.held_weapon:
			return
		player.held_weapon.handle_ui()
		player.held_weapon.handle_ui_reload()
		
		player_healthbar.value = player.health
	if enemy:
		enemy_healthbar.value = enemy.health
	if get_tree().paused:
		self.hide()
	elif player.health <= 0.0:
		self.hide()
	else:
		self.show()
			
	
