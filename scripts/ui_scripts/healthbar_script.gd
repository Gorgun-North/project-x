extends Control

var player: entity
var enemy: entity

@export var player_healthbar: ProgressBar
@export var enemy_healthbar : ProgressBar

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	enemy = get_tree().get_first_node_in_group("Enemy")
	
	if player:
		player_healthbar.max_value = player.health
	if enemy:
		enemy_healthbar.max_value = enemy.health
	
func _process(_delta: float) -> void:
	if player:
		player_healthbar.value = player.health
		if player.health <= 0.0:
			self.hide()
	if enemy:
		enemy_healthbar.value = enemy.health
	
