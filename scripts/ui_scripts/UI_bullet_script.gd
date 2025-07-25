extends Control
class_name bullet_UI

var get_bullet_sprite: Sprite2D
var is_bullet_loaded: bool = true
@export var anim_player: AnimationPlayer

func _ready() -> void:
	get_bullet_sprite = $Sprite2D
	
	
func play_bullet_ui_animation(bullet_shot: bool):
	if bullet_shot == true:
		anim_player.play("shoot_bullet")
		is_bullet_loaded = false
	elif bullet_shot == false:
		anim_player.play("reload_bullet")
		await anim_player.animation_finished
		is_bullet_loaded = true
	
func set_bullet_frame(new_frame: int):
	get_bullet_sprite.frame = new_frame
