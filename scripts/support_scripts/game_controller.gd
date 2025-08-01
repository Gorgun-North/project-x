extends Node
class_name game_controller

@export var navmesh: NavigationRegion2D
@export var game_music: AudioStreamPlayer
@export var current_stage: int


signal bake_navmesh

#func _process(_delta: float) -> void:
	#print(Engine.get_frames_per_second())

func _ready() -> void:
	game_music.play(26.0)
	bake_navmesh.connect(_on_bake_navmesh)
	if navmesh:
		await get_tree().process_frame
		navmesh.bake_navigation_polygon()
		
func _on_bake_navmesh():
	if !is_inside_tree() or !navmesh:
		return
	
	
	var _navpol: NavigationPolygon = navmesh.navigation_polygon
	
	while navmesh.is_baking() == true:
		if !is_inside_tree() or !navmesh.is_inside_tree():
			return
		
		await get_tree().process_frame
	
	navmesh.bake_navigation_polygon()

func _on_music_player_finished() -> void:
	game_music.play(26.0)
