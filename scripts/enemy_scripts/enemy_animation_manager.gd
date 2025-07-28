extends Node
class_name enemy_animation_manager

@export var state_machine_controller_instance: state_machine_controller
@export var body: entity
@export var anim_player: AnimationPlayer

func _physics_process(_delta: float) -> void:
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("idle"):
		anim_player.play("idle_right")
	elif state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("move"):
		if abs(body.velocity.x) > abs(body.velocity.y):
			if body.velocity.x > 0:
				anim_player.play("walk_right")
			else:
				anim_player.play("walk_left")
		else:
			if body.velocity.y > 0:
				anim_player.play("walk_front")
			else:
				anim_player.play("walk_back")
	elif state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("dodge"):
		if abs(body.velocity.x) > abs(body.velocity.y):
			if body.velocity.x > 0:
				anim_player.play("dodge_right")
			else:
				anim_player.play("dodge_left")
		else:
			if body.velocity.y > 0:
				anim_player.play("dodge_front")
			else:
				anim_player.play("dodge_back")
