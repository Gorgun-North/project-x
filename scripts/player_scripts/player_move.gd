extends states
class_name player_move

#Exported values for speed and such for quick adjustments
@export var player_speed : float
@export var powerup_speed: float
@export var speed_powerup_timer_duration: float = 10.0

var input_vector : Vector2 = Vector2.ZERO
var speed_powerup_timer: float
var currently_using_powerup: bool = false
var current_speed: float

var last_input_vector : Vector2 #Set the last direction where the player was moving towards for decelaration in idle state

func _ready() -> void:
	speed_powerup_timer = speed_powerup_timer_duration

func check_speed_powerup() -> void:
	var player = get_tree().get_first_node_in_group("Player")
		
	if player is entity:
		if player.picked_up_powerup != "":
			print(player.picked_up_powerup)
		if player.picked_up_powerup == "speed":
			currently_using_powerup = true
			player.picked_up_powerup = ""

func determine_speed() -> void:
	if currently_using_powerup == true:
		speed_powerup_timer -= get_process_delta_time()
		current_speed = powerup_speed
		
		if speed_powerup_timer <= 0.0:
			currently_using_powerup = false
			speed_powerup_timer = speed_powerup_timer_duration
	else:
		current_speed = player_speed
	

func _process(delta: float) -> void:
	check_speed_powerup()
	determine_speed()
	

#Basic movement applied to character
func Physics_Update(_delta) -> void:
	
	input_vector.x = Input.get_action_strength("WASD_RIGHT") - Input.get_action_strength("WASD_LEFT")
	input_vector.y = Input.get_action_strength("WASD_DOWN") - Input.get_action_strength("WASD_UP")
	input_vector = input_vector.normalized() 
	
	body.velocity = input_vector * current_speed

	if input_vector == Vector2.ZERO:
		Transitioned.emit(self, "idle")
	else:
		last_input_vector = input_vector #Keep the last input up to date until the state changes
		
func Exit():
	body.velocity = last_input_vector * player_speed
	
	
