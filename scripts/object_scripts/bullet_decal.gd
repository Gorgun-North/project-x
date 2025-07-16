extends Node2D
class_name bullet_decal

var velocity = Vector2.ZERO
var angular_speed = 0.0

func _ready():
	velocity = Vector2.LEFT.rotated(rotation) * randf_range(60, 100)
	var spin = randf_range(3.0, 7.0)
	if randf() > 0.5:
		spin *= -1


func _process(delta):
	position += velocity * delta
	rotation += angular_speed * delta
	velocity.x = move_toward(velocity.x, 0, delta * 40.0)  # simulate friction
	velocity.y = move_toward(velocity.y, 0, delta * 40.0)  # simulate friction
