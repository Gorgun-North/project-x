extends states
class_name enemy_move2

@export var max_speed     : float = 400.0
@export var arrive_radius : float = 4.0
@export var pause_seconds : float = 0.3

@export var nav: NavigationAgent2D
var _pause_timer : float = 0.0

var rng = RandomNumberGenerator.new()

func _Entered() -> void:
	rng.randomize()
	_pick_new_destination()


func Physics_Update(delta: float) -> void:
	if nav.is_navigation_finished():
		body.velocity = Vector2.ZERO
		_pause_timer -= delta
		if _pause_timer <= 0.0:
			_pick_new_destination()
		return

	var steer_target: Vector2 = nav.get_next_path_position()
	body.look_at(nav.get_next_path_position())
	var dir: Vector2 = (steer_target - body.global_position).normalized()

	body.velocity = dir * max_speed


func _pick_new_destination() -> void:
	var map_rid: RID = nav.get_navigation_map()

	# NavigationServer2D can hand us a genuine point ON the mesh:
	var random_point := NavigationServer2D.map_get_random_point(
		map_rid,
		1,          # navigation layer mask (default “1”)
		false       # fast random pick; set true for perfect uniformity
	)

	nav.set_target_position(random_point)
	_pause_timer = pause_seconds
