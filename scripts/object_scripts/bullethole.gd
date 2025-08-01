extends Node2D
class_name bullethole

@export var bullet_sprite: Sprite2D
@export var bullet_particles: GPUParticles2D
var rng = RandomNumberGenerator.new()
var gravity_strength: float = 600


func _ready() -> void:
	if bullet_sprite:
		var get_bullethole_frames = bullet_sprite.hframes - 1
		bullet_sprite.frame = rng.randi_range(0, get_bullethole_frames)

	if bullet_particles:
		if self.rotation_degrees > 45 and self.rotation_degrees < 135:
			bullet_particles.rotation = bullet_particles.rotation + PI
		elif self.rotation_degrees < -45 and self.rotation_degrees > -135:
			bullet_particles.rotation = bullet_particles.rotation - PI
		else:
			bullet_particles.rotation = 0
		bullet_particles.emitting = true


	
