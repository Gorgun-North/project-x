extends Node

@export var entity_instance: entity
@export var particle_system: GPUParticles2D

func _process(_delta: float) -> void:
	if !is_instance_valid(entity_instance):
		particle_system.emitting = true
		
