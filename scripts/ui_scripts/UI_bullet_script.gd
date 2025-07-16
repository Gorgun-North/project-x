extends Control
class_name bullet_UI

var get_bullet_sprite: Sprite2D

func _ready() -> void:
	get_bullet_sprite = $Sprite2D
	
func set_bullet_frame(new_frame: int):
	get_bullet_sprite.frame = new_frame
