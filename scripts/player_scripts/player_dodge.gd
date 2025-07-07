extends states
class_name player_dodge


@export var dodge_speed: float = 700
@export var dodge_duration: float = 0.3

@export var dodge_cooldown_timer: Timer
@export var dodge_cooldown: float

var dodge_direction: Vector2
var dodge_timer: float = 0.0

@export var input_mode: mouse_look
@export var aim_ray: RayCast2D

func _ready() -> void:
	dodge_cooldown_timer.wait_time = dodge_cooldown

func Entered() -> void:
	
	dodge_timer = dodge_duration
	var mouse_pos = body.get_global_mouse_position()
	
	if input_mode.mouse_look_mode == "mouse":
		dodge_direction = (mouse_pos - body.global_position).normalized()
	if input_mode.mouse_look_mode == "controller":
		dodge_direction = (aim_ray.get_collision_point()- body.global_position).normalized()
	
func Physics_Update(delta) -> void:
	if dodge_direction != Vector2.ZERO:
		dodge_timer -= delta
		body.velocity = dodge_direction * dodge_speed
		if dodge_timer <= 0.0:
			Transitioned.emit(self, "idle")
			
func Exit() -> void:
	if dodge_cooldown_timer.is_stopped():
		dodge_cooldown_timer.start()

func _physics_process(_delta: float) -> void:
	if !dodge_cooldown_timer.is_stopped():
		Transitioned.emit(self, "Idle")
