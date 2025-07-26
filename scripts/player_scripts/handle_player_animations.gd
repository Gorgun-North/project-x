extends Node
class_name handle_player_animations

@export var anim_player: AnimationPlayer
@export var shadow_anim_player: AnimationPlayer
@export var gun_anim_player: AnimationPlayer
@export var body: CharacterBody2D
@export var sprite2D: Sprite2D

func handle_screen_dir(mouse_pos: Vector2, viewport_size: Vector2) -> String:
	var screen_center: Vector2 = viewport_size / 2.0
	var direction: Vector2 = (mouse_pos - screen_center).normalized()
	var angle_degrees: float = rad_to_deg(atan2(direction.y, direction.x))

	const RIGHT_MIN = -45.0
	const RIGHT_MAX =  45.0
	const BOTTOM_MIN =  45.0
	const BOTTOM_MAX = 135.0
	const TOP_MIN = -135.0
	const TOP_MAX = -45.0

	if angle_degrees >= RIGHT_MIN and angle_degrees < RIGHT_MAX:
		return "RIGHT"
	elif angle_degrees >= BOTTOM_MIN and angle_degrees < BOTTOM_MAX:
		return "BOTTOM"
	elif angle_degrees >= TOP_MIN and angle_degrees < TOP_MAX:
		return "TOP"
	else:
		return "LEFT"



func _process(_delta: float) -> void:
	shadow_anim_player.play("shadow_move")
	$"../../reload_ui_timer_placeholder".global_position = body.global_position
	
	var viewport_size: Vector2 = get_window().get_size()
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var get_looking_direction = handle_screen_dir(mouse_pos, viewport_size)
	
	if body.velocity == Vector2.ZERO:
		match get_looking_direction:
				 
			"LEFT":
				anim_player.play("Idle_left")
				gun_anim_player.play("gun_up_left")
			"RIGHT":
				anim_player.play("Idle_right")
			"BOTTOM":
				anim_player.play("Idle_front")
			"TOP":
				anim_player.play("Idle_back")
	else:
		match get_looking_direction:
				 
			"LEFT":
				anim_player.play("Walk_left")
			"RIGHT":
				anim_player.play("Walk_right")
			"BOTTOM":
				anim_player.play("Walk_forwards")
			"TOP":
				anim_player.play("Walk_back")
		
		
