extends Node

@export var powerup_instance: power_up

@export var heal_amount: float = 10

func get_hp_back(object: entity, amount: float) -> void:
	if object.health < object.max_health:
		object.health += amount
		self.queue_free()
	
func _process(delta: float) -> void:
	if !is_instance_valid(powerup_instance):
		self.queue_free()
		return
	
	var player = get_tree().get_first_node_in_group("Player")
	var enemy = get_tree().get_first_node_in_group("Enemy")
	
	if player is entity or enemy is entity:
		var overlapping_entity = powerup_instance.check_for_item_pickup()
		
		if overlapping_entity == null:
			return
		elif overlapping_entity == player:
			get_hp_back(player, heal_amount)
		elif overlapping_entity == enemy:
			get_hp_back(enemy, heal_amount)
