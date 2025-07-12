extends Node

@export var powerup_instance: power_up

@export var heal_amount: float = 10

func get_player_hp_back(object: entity, amount: float) -> void:
	if object.health < object.max_health:
		object.health += amount
		self.queue_free()
	
func _process(delta: float) -> void:
	if !is_instance_valid(powerup_instance):
		self.queue_free()
		return
	
	if powerup_instance.check_for_item_pickup():
		var player = get_tree().get_first_node_in_group("Player")
		
		if player is entity:
			get_player_hp_back(player, heal_amount)
