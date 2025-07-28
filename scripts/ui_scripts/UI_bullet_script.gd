extends Control
class_name bullet_UI

var get_bullet_sprite: Sprite2D
var is_bullet_loaded: bool = true
@export var anim_player: AnimationPlayer

var bullet_full: bool = true

func _ready() -> void:
	get_bullet_sprite = $Sprite2D
	
func set_bullet_frame(new_frame: int):
	get_bullet_sprite.frame = new_frame
