extends Control

func _ready() -> void:
	hide()

func resume() -> void:
	self.hide()
	get_tree().paused = false


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()
