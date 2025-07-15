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
	
