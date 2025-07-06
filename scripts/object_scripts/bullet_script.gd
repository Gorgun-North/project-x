extends Area2D
class_name bullet

@export var bullet_speed: float = 500.0

var dir: Vector2

func _ready() -> void:
	
	var mouse_pos = get_global_mouse_position()
	dir = (mouse_pos - self.global_position).normalized()

func _physics_process(delta: float) -> void:
	position += dir * bullet_speed * delta
	
	if self.has_overlapping_bodies():
		print(self.get_overlapping_bodies())
		self.queue_free()
