extends Area2D
@export var root: StaticBody2D
@export var object: entity
@export var animplayer: AnimationPlayer
@export var colshape  : CollisionShape2D
@export var explosion_light: PointLight2D
@export var damage: float = 30.0
@export var knockback_force: float = 2000.0
@export var knockback_duration: float = 0.3
@export var audio_player: AudioStreamPlayer2D
	
const AUDIO_STOP_TIME: float = 3.0
	
func _physics_process(_delta: float) -> void:
	
	
	if !is_instance_valid(object):
		
		for i in get_overlapping_bodies():
			if i is entity:
				var dir = -(self.global_position - i.global_position)
				i.take_damage(damage)
				   
				#object is null because it is no longer valid
				i.got_hit.emit(null, dir, knockback_force, knockback_duration)
				
				colshape.disabled = true
		for i in get_overlapping_areas():
			if i is power_up:
				i.queue_free()
		
		#explosion_light.visible = true
		if audio_player.playing == false:
			audio_player.play(0.0)
			animplayer.play("explode")
		var explosion_remains = preload("res://scenes/misc_scenes/explosion_remains.tscn").instantiate()
		explosion_remains.global_position = root.global_position
		get_tree().current_scene.add_child(explosion_remains)
		if audio_player.get_playback_position() > AUDIO_STOP_TIME:
			print("dwawdwa")
			root.queue_free()
	
