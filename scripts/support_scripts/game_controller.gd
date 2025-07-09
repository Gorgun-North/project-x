extends Node
class_name game_controller

@export var navmesh: NavigationRegion2D

signal bake_navmesh


func _ready() -> void:
	bake_navmesh.connect(_on_bake_navmesh)
	if navmesh:
		navmesh.bake_navigation_polygon()
		
func _on_bake_navmesh():
	if !is_inside_tree() or !navmesh:
		return
	
	
	var navpol: NavigationPolygon = navmesh.navigation_polygon
	
	while navmesh.is_baking() == true:
		if !is_inside_tree():
			return
		
		await get_tree().process_frame
	
	navmesh.bake_navigation_polygon()
