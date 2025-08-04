extends Node2D
class_name bullet_decal

var velocity = Vector2.ZERO
var angular_speed = 0.0

func _ready():
	var timer = Timer.new()
	timer.wait_time = 180.0
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_on_lifetime_timeout"))
	add_child(timer)
	
	velocity = Vector2.LEFT.rotated(rotation) * randf_range(60, 100)
	var spin = randf_range(3.0, 7.0)
	if randf() > 0.5:
		spin *= -1


func _process(delta):
	position += velocity * delta
	rotation += angular_speed * delta
	velocity.x = move_toward(velocity.x, 0, delta * 40.0)  # simulate friction
	velocity.y = move_toward(velocity.y, 0, delta * 40.0)  # simulate friction

func _on_lifetime_timeout():
	queue_free()
