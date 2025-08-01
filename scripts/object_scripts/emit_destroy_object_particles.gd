extends Node

@export var entity_instance: entity
@export var particle_system: GPUParticles2D

func _ready() -> void:
	particle_system.global_position = self.global_position

func _process(_delta: float) -> void:
	if !is_instance_valid(entity_instance):
		particle_system.emitting = true
		
