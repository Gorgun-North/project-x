extends Control

@export var audio: AudioStreamPlayer

func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_scenes/root.tscn")
	
func _process(_delta: float) -> void:
	if audio.playing == false:
		audio.play()
		
	if audio.get_playback_position() > 27.0:
		audio.stop()
	


func _on_audio_stream_player_finished() -> void:
	audio.play()
