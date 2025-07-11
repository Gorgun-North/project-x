extends Node

@export var powerup_instance: power_up

func _process(delta: float) -> void:
	if !is_instance_valid(powerup_instance):
		self.queue_free()
		return
	
	if powerup_instance.check_for_item_pickup():
		var player = get_tree().get_first_node_in_group("Player")
	
		if player is entity:
			player.picked_up_powerup = "speed"
			self.queue_free()
	
