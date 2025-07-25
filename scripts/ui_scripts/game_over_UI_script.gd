extends Control

@export var anim_player: AnimationPlayer
var is_in_death_screen: bool = false
var just_died: bool = false

func _ready() -> void:
	hide()

func resume() -> void:
	self.hide()
	just_died = false
	is_in_death_screen = false


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_restart_pressed() -> void:
	anim_player.play("you_died")
	await anim_player.animation_finished
	resume()
	
	var bullet_decals = get_tree().get_nodes_in_group("bullet_decal")
	
	for i in bullet_decals:
		i.queue_free()
	
	get_tree().reload_current_scene()
