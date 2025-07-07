extends Control
class_name pausemenu

func _ready() -> void:
	self.hide()

func resume() -> void:
	self.hide()
	get_tree().paused = false
	
func pause() -> void:
	self.show()
	get_tree().paused = true
	$PanelContainer/VBoxContainer/Resume.grab_focus()



func _on_resume_pressed() -> void:
	print("dwwawa")
	resume()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().quit()
