extends Node
class_name enemy_reload

@export var state_machine_controller_instance: state_machine_controller
@export var reload_bar: ProgressBar
@export var body: entity
@export var reload_time: float = 2.0

var reload_timer: float
var bool_for_printline: bool = false
const RELOAD_BAR_POSITION: Vector2 = Vector2(-200, -100)

func _ready() -> void:
	reload_timer = reload_time
	reload_bar.min_value = 0.0
	reload_bar.max_value = reload_time
	reload_bar.value = reload_time
	reload_bar.visible = false
	

func _physics_process(_delta: float) -> void:
	$"../../reload_ui_timer_placeholder".global_rotation = 0.0
	
	
func _process(delta: float) -> void:
	
	if body.bullets_left > 0:
		reload_bar.visible = false
		return
		
	if state_machine_controller_instance.current_state == state_machine_controller_instance.states_dict.get("melee_attack"):
		reload_timer = reload_time
		reload_bar.visible = false
		return

	if bool_for_printline == false:
		print("NEED TO RELOAD!")
		bool_for_printline = true

	reload_bar.visible = true
	reload_timer -= delta
	reload_bar.value = reload_timer
	
	if reload_timer <= 0.0:
		reload_timer = reload_time
		body.bullets_left = body.max_bullets
		reload_bar.value = 0.0
		reload_bar.visible = false
		bool_for_printline = false
