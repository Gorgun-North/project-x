extends Control

var player: entity
var enemy: entity

@export var player_healthbar: ProgressBar
@export var enemy_healthbar : ProgressBar

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	enemy = get_tree().get_first_node_in_group("Enemy")
	
	player_healthbar.max_value = player.health
	enemy_healthbar.max_value = enemy.health
	
func _process(_delta: float) -> void:
	player_healthbar.value = player.health
	if enemy:
		enemy_healthbar.value = enemy.health
	
	if player.health <= 0.0:
		self.hide()
