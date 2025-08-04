extends Node

@export var powerup_instance: power_up

@export var heal_amount: int = 10

func get_hp_back(object: entity, amount: int) -> void:
	object.health += amount
	self.queue_free()
	
func _process(_delta: float) -> void:
	if !is_instance_valid(powerup_instance):
		queue_free()
		return
	
	var player = get_tree().get_first_node_in_group("Player")
	var enemy = get_tree().get_first_node_in_group("Enemy")
	
	if player is entity or enemy is entity:
		var overlapping_entity = powerup_instance.check_for_item_pickup()
		if overlapping_entity == null:
			return
		elif overlapping_entity.health == overlapping_entity.max_health:
			return

		var popup_scene = preload("res://scenes/UI_scenes/popup_text.tscn")
		var popup_instance = popup_scene.instantiate()

		if overlapping_entity == player:
			popup_instance.set_picked_up_powerup_event("player gained +" + str(heal_amount) + " health back!")
			popup_instance.global_position = player.global_position
			get_hp_back(player, heal_amount)

		elif overlapping_entity == enemy:
			popup_instance.set_picked_up_powerup_event("enemy gained +" + str(heal_amount) + " health back!")
			popup_instance.global_position = enemy.global_position
			get_hp_back(enemy, heal_amount)

		get_tree().root.add_child(popup_instance)
