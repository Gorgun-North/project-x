extends Camera2D
@export var entity_instance: entity

@export var shake_intensity_max: float = 8.0
@export var active_shake_time_duration: float = 0.5
@export var reset_camera_zoom: float = 0.25
var shake_intensity: float
var active_shake_time: float

var noise_frequency: float = 2.0

@export var shake_fadeout: float = 5.0

var reset_shake: float = 10.5

var shake_time: float = 0.0
var shake_time_speed: float = 20.0

var noise = FastNoiseLite.new()

var last_player_health: int

func _ready() -> void:
	last_player_health = entity_instance.health
	self.zoom.x = reset_camera_zoom
	self.zoom.y = reset_camera_zoom

func _process(_delta: float) -> void:
	if entity_instance.health <= 0.0:
		return
	
	if last_player_health > entity_instance.health:
		screen_shake()
	
	last_player_health = entity_instance.health

func _physics_process(delta: float) -> void:
	if active_shake_time > 0.0:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		
		self.offset = Vector2(
			noise.get_noise_2d(shake_time, 0) * shake_intensity,
			noise.get_noise_2d(0, shake_time) * shake_intensity
		)
		
		shake_intensity = max(shake_intensity - shake_fadeout * delta, 0)
	else:
		self.offset = lerp(offset, Vector2.ZERO, reset_shake * delta)
	
func screen_shake() -> void:
	randomize()
	noise.seed = randi()
	noise.frequency = noise_frequency
	shake_intensity = shake_intensity_max
	active_shake_time = active_shake_time_duration
	shake_time = 0.0
