extends Node2D
class_name revolver

@export var weapon_instance: weapon

const RELOAD_AMOUNT: int = 6
const BULLET_DECAL_SCENE_PATH: String = "res://scenes/misc_scenes/bullet_decal.tscn"
const BULLET_SCENE_PATH: String = "res://scenes/object_scenes/bullet.tscn"
	
	
func _process(_delta: float) -> void:
	
	weapon_instance.reload_weapon(RELOAD_AMOUNT)
	
	if weapon_instance.is_attacking_flag == true:
		
		weapon_instance.spawn_bullet(BULLET_SCENE_PATH, BULLET_DECAL_SCENE_PATH)
