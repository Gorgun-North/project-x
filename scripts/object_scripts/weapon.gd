extends Marker2D
class_name weapon

@export var anim_player: AnimationPlayer
@export var sprite2D   : Sprite2D
@export var bullet_spawn_marker: Node2D

@export var correct_gun_rotation_left: float = 45
@export var correct_gun_rotation_right: float = 135
@export var marker_pos_left: Vector2
@export var marker_pos_right: Vector2

@export var max_bullets: int = 6

func _ready() -> void:
	anim_player.anim
	
	var entity_attacks = get_tree().get_first_node_in_group("entity_attack")
	entity_attacks.connect("is_attacking", _on_attack)
	anim_player.play("gun_idle")

func _physics_process(_delta: float) -> void:
	var mouse_dir = get_global_mouse_position() - self.global_position
	look_at(get_global_mouse_position())

	if mouse_dir.x < 0.0:
		sprite2D.rotation = deg_to_rad(correct_gun_rotation_right)
		sprite2D.flip_h = false
		bullet_spawn_marker.global_position = to_global(marker_pos_right)
	elif mouse_dir.x >= 0.0:
		sprite2D.flip_h = true
		sprite2D.rotation = deg_to_rad(correct_gun_rotation_left)
		bullet_spawn_marker.global_position = to_global(marker_pos_left)
	
		
		
func _on_attack():
	anim_player.stop()
	anim_player.play("gun_fire")
	await anim_player.animation_finished
	anim_player.play("gun_idle")
	
