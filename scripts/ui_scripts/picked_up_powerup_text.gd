extends Control
class_name powerup_text


func set_picked_up_powerup_event(text: String):
	print("I LIVEE!!")
	$Control/HBoxContainer/RichTextLabel.text = text
	$AnimationPlayer.play("move_up")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "move_up":
		self.queue_free()
