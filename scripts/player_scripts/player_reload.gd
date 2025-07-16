extends Node
class_name player_reload

@export var reload_time: float = 0.5
@export var body: entity
@export var reload_bar: ProgressBar
var player_reloads_bullet: bool = false
var reload_timer: float

func _ready() -> void:
	reload_timer = reload_time
	reload_bar.min_value = 0.0
	reload_bar.max_value = reload_time
	reload_bar.value = reload_time
	reload_bar.visible = false

func reload_gun():
	
	if body.bullets_left >= body.max_bullets:
		return
	
	if Input.is_action_just_pressed("RELOAD_BUTTON"):
		player_reloads_bullet = true
	
	if reload_time == reload_timer:
		reload_bar.visible = false
	
	if player_reloads_bullet == true:
		
		reload_timer -= get_process_delta_time()
		reload_bar.value = reload_timer
		reload_bar.visible = true
		
		if reload_timer <= 0.0:
			body.bullets_left = body.max_bullets
			
			
			reload_timer = reload_time
			player_reloads_bullet = false
			reload_bar.visible = false
			reload_bar.value = 0.0
		
func _process(_delta: float) -> void:
	reload_gun()
