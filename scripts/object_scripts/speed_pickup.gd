extends Node

@export var powerup_instance: power_up

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
		elif overlapping_entity == enemy:
			enemy.picked_up_powerup = "speed"
			self.queue_free()
		elif overlapping_entity == player:
			player.picked_up_powerup = "speed"
			self.queue_free()
		
	
