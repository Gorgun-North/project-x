extends Node

@export var powerup_instance: power_up
@export var audio_stream_player: AudioStreamPlayer2D


func _process(_delta: float) -> void:
	if is_instance_valid(powerup_instance):
		powerup_instance.activate_powerup("speed")
	else:
		if audio_stream_player.playing == false:
			audio_stream_player.play(0.0)
		await audio_stream_player.finished
		self.queue_free()
		
	
