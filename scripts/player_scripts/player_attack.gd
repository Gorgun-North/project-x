extends Node

@export var body: CharacterBody2D

@export var player_hitbox_size: float = 70.0

func _input(event: InputEvent) -> void:
	#Checks if the body is selected and if so, lets the characterbody2d look at the mouse
	#googoogaagaa
	
	if Input.is_action_just_pressed("LMB"):
		if body:
			var bullet = preload("res://scenes/object_scenes/bullet.tscn").instantiate()
			
			var mouse_pos := body.get_global_mouse_position()
			var shoot_angle : float = (mouse_pos - body.global_position).angle()
			
			var bullet_dir: Vector2 = (mouse_pos - body.global_position).normalized()
			
			bullet.global_position = body.global_position
			bullet.rotation = shoot_angle
			
			get_tree().root.add_child(bullet)
			
		else:
			print("body is not selected, attach it to this node: ", self)
