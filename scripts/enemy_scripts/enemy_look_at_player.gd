extends Node
class_name enemy_look_at_player

@export var body: CharacterBody2D
@export var enemy_to_player_ray: RayCast2D

var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta: float) -> void:
	enemy_to_player_ray.global_position = body.global_position
	
	if player:
		enemy_to_player_ray.target_position = enemy_to_player_ray.to_local(player.global_position)
	
