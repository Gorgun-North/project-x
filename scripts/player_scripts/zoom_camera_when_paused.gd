extends Node

@export var camera: Camera2D
@export var entity_instance: entity
@export var paused_camera_zoom: float = 0.5
@export var go_to_pause_zoom_time: float = 0.5
var normal_camera_zoom: float

var pause_menu

func _ready() -> void:
	if camera:
		normal_camera_zoom = camera.zoom.x
	pause_menu = get_tree().get_first_node_in_group("pause_menu")
	
func _process(_delta: float) -> void:
	if entity_instance.health <= 0.0:
		return
	
	if pause_menu:
		var tween_x = get_tree().create_tween()
		var tween_y = get_tree().create_tween()
		tween_x.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween_y.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		
		if pause_menu.is_in_pause_screen == true:
			tween_x.tween_property(camera, "zoom:x", paused_camera_zoom, go_to_pause_zoom_time)
			tween_y.tween_property(camera, "zoom:y", paused_camera_zoom, go_to_pause_zoom_time)
		elif pause_menu.is_in_pause_screen == false:
			
			tween_x.tween_property(camera, "zoom:x", normal_camera_zoom, go_to_pause_zoom_time)
			tween_y.tween_property(camera, "zoom:y", normal_camera_zoom, go_to_pause_zoom_time)
