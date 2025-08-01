extends Node
class_name player_powerup_controller

signal rapid_fire_powerup

@export var body: entity
var base_speed: float
@export var powerup_speed: float = 2000.0
@export var speed_powerup_duration: float = 10.0
@export var rapid_fire_powerup_duration: float = 10.0

var speed_powerup_timer: float
var rapid_fire_powerup_timer: float

var speed_active_flag: bool = false
var rapid_fire_active_flag: bool = false

func _ready() -> void:
	speed_powerup_timer = speed_powerup_duration
	base_speed = body.speed

func reset_powerup_indication(powerup_name: String) -> void:
	if body.picked_up_powerup == powerup_name:
		body.picked_up_powerup = ""

func handle_incoming_powerup_activations() -> void:
	if body.picked_up_powerup == "speed":
		reset_powerup_indication("speed")
		speed_active_flag = true
		
func handle_speed_powerup(delta) -> void:
	if speed_active_flag == true:
		speed_powerup_timer -= delta
		body.speed = powerup_speed
		
		if speed_powerup_timer <= 0.0:
			speed_active_flag = false
			body.speed = base_speed
			speed_powerup_timer = speed_powerup_duration

func _process(delta: float) -> void:
	handle_incoming_powerup_activations()
	handle_speed_powerup(delta)
		
