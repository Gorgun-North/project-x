extends Area2D
class_name power_up

func _ready() -> void:
	$AnimationPlayer.play("powerup_move")
	
func check_for_item_pickup() -> entity:
	if has_overlapping_bodies():
		for body in get_overlapping_bodies():
			if body.name.begins_with("Player") or body.name.begins_with("Enemy"):
				return body
	return null
	
func activate_powerup(powerup_name: String) -> void:
	if !is_instance_valid(self):
		self.queue_free()
		return
		
	var player = get_tree().get_first_node_in_group("Player")
	var enemy = get_tree().get_first_node_in_group("Enemy")
	
	if player is entity or enemy is entity:
		var overlapping_entity = check_for_item_pickup()
		
		if overlapping_entity == null:
			return
		elif overlapping_entity == enemy:
			enemy.picked_up_powerup = powerup_name
			self.queue_free()
		elif overlapping_entity == player:
			player.picked_up_powerup = powerup_name
			self.queue_free()
	
