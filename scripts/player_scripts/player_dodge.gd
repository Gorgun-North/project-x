extends states
class_name player_dodge


@export var dodge_speed: float = 700
@export var dodge_duration: float = 0.3

@export var dodge_cooldown_timer: Timer
@export var dodge_cooldown: float

var dodge_direction: Vector2
var dodge_timer: float = 0.0

func _ready() -> void:
	dodge_cooldown_timer.wait_time = dodge_cooldown

func Entered() -> void:
	
	dodge_timer = dodge_duration
	var mouse_pos = body.get_global_mouse_position()
	dodge_direction = (mouse_pos - body.global_position).normalized()
	
func Physics_Update(delta) -> void:
	if dodge_direction != Vector2.ZERO:
		dodge_timer -= delta
		body.velocity = dodge_direction * dodge_speed
		if dodge_timer <= 0.0:
			Transitioned.emit(self, "idle")
			
func Exit() -> void:
	if dodge_cooldown_timer.is_stopped():
		dodge_cooldown_timer.start()

func _physics_process(delta: float) -> void:
	print(dodge_cooldown_timer.time_left)
	if !dodge_cooldown_timer.is_stopped():
		Transitioned.emit(self, "Idle")
