extends Area2D
@export var root: Node2D
@export var object: entity
@export var animplayer: AnimationPlayer
@export var colshape  : CollisionShape2D
@export var damage: float = 30.0
@export var knockback_force: float = 2000.0
@export var knockback_duration: float = 0.3
	
func _physics_process(_delta: float) -> void:
	
	
	if !is_instance_valid(object):
		for i in get_overlapping_bodies():
			print(i)
			if i is entity:
				var dir = -(self.global_position - i.global_position)
				i.take_damage(damage)
				
				#object is null because it is no longer valid
				i.got_hit.emit(null, dir, knockback_force, knockback_duration)
				colshape.disabled = true
		for i in get_overlapping_areas():
			if i is power_up:
				i.queue_free()
				
		animplayer.play("explode")
		await animplayer.animation_finished
		root.queue_free()
	
