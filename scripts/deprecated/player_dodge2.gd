extends states
class_name player_dodge2

@export var dodge_speed: float = 700
@export var dodge_duration: float = 0.3

@export var state_machine_controller_instance: state_machine_controller

@export var dodge_cooldown_timer: Timer
@export var dodge_cooldown: float

var dodge_timer: float = 0.0
var input_vector : Vector2 = Vector2.ZERO

@export var input_mode: mouse_look
@export var aim_ray: RayCast2D

func _ready() -> void:
	dodge_cooldown_timer.wait_time = dodge_cooldown

func Physics_Update(delta) -> void:
	dodge_timer -= delta
	
	body.velocity = input_vector * dodge_speed
	
	
	if dodge_timer <= 0.0:
		Transitioned.emit(self, "Idle")

func Entered() -> void:
	dodge_timer = dodge_duration
	
	
func _physics_process(delta: float) -> void:
	#print(state_machine_controller_instance.current_state)
	#print(dodge_cooldown_timer.time_left)
	print(input_vector)
	
	if input_vector == Vector2.ZERO:
		print("sdfujd's")
	
	if !dodge_cooldown_timer.is_stopped():
		return
		
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("dodge"):
		return
	
	if Input.is_action_pressed("SPACEBAR"):
		input_vector.x = Input.get_action_strength("WASD_RIGHT") - Input.get_action_strength("WASD_LEFT")
		input_vector.y = Input.get_action_strength("WASD_DOWN") - Input.get_action_strength("WASD_UP")
		input_vector = input_vector.normalized() 
		
		if input_vector != Vector2.ZERO:
			Transitioned.emit(state_machine_controller_instance.current_state, "Dodge")
		
		
	
	
	
			
func Exit() -> void:
	input_vector = Vector2.ZERO
	
	if dodge_cooldown_timer.is_stopped():
		dodge_cooldown_timer.start()
