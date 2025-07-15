extends Node

@export var powerup_instance: power_up

func _process(_delta: float) -> void:
	if is_instance_valid(powerup_instance):
		powerup_instance.activate_powerup("double_damage")
	else:
		self.queue_free()
		
	
