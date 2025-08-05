extends Node2D
class_name initiate_weapon_instance

signal ui_bullet_fired(index: int)
signal ui_bullet_reloaded(index: int, bullet_reload_amount: int)
signal initiate_bullet_ui(clip_amount: int)

@onready var weapon_instance: weapon = $weapon_prefab

@export var max_bullets: int = 6
@export var weapon_damage: float = 10.0
@export var rate_of_fire: float = 0.5
@export var reload_time: float = 0.8
@export var wielder_of_weapon: entity
@export var reload_amount: int = 1
@export var gun_reload_sound_pitch_scale = 2.0

const BULLET_DECAL_SCENE_PATH: String = "res://scenes/misc_scenes/bullet_decal.tscn"
const BULLET_SCENE_PATH: String = "res://scenes/object_scenes/bullet.tscn"
const BULLET_UI_SCENE_PATH: String = "res://scenes/UI_scenes/bullet_ui_element.tscn"

var sent_reload_request_flag: bool = false
var reload_anim_duration: float
var reload_anim_timer: float
	
func _reload_lever_action(reload_amount: int) -> void:
	if weapon_instance.get_weapon_states() != weapon_instance.weapon_states.RELOADING:
		return

	if not sent_reload_request_flag:
		_start_reload_animation(reload_amount)

	_update_reload_timers()

	if _is_reload_complete():
		_finish_reload(reload_amount)

# --- Helper Functions ---

func _start_reload_animation(reload_amount: int) -> void:
	if wielder_of_weapon.name.begins_with("Enemy"):
		return
	
	var bullets_needed = weapon_instance.max_bullets - weapon_instance.bullets_left
	var bullets_to_reload = min(reload_amount, bullets_needed)

	reload_anim_timer = reload_anim_duration * bullets_to_reload
	emit_signal("ui_bullet_reloaded", weapon_instance.bullets_left - 1, bullets_to_reload)
	weapon_instance.gun_reload_sound.pitch_scale = gun_reload_sound_pitch_scale
	weapon_instance.gun_reload_sound.play(0.0)
	
	sent_reload_request_flag = true

func _update_reload_timers() -> void:
	if wielder_of_weapon.name.begins_with("Enemy"):
		reload_anim_timer = 0.0
	else:
		reload_anim_timer -= get_process_delta_time()
	
	
	weapon_instance.reload_bar.visible = true
	weapon_instance.reload_timer -= get_process_delta_time()
	weapon_instance.reload_bar.value = weapon_instance.reload_timer

func _is_reload_complete() -> bool:
	return weapon_instance.reload_timer <= 0.0 and reload_anim_timer <= 0.0

func _finish_reload(reload_amount: int) -> void:
	sent_reload_request_flag = false
	weapon_instance.reload_bar.visible = false
	weapon_instance.reload_bar.value = reload_time
	weapon_instance.set_weapon_states(weapon_instance.weapon_states.IDLE)
	weapon_instance.reload_timer = weapon_instance.reload_time
	weapon_instance.bullets_left += reload_amount
	weapon_instance.bullets_left = min(weapon_instance.bullets_left, weapon_instance.max_bullets)


func _ready() -> void:
	weapon_instance._setup(max_bullets,
	 weapon_damage,
	 rate_of_fire,
	 reload_time,
	 wielder_of_weapon
	)
	
	var bullet_ui_scene = preload(BULLET_UI_SCENE_PATH)
	var bullet_ui_instance: Node = bullet_ui_scene.instantiate()
	
	# Safely get the animation length
	if bullet_ui_instance.has_node("AnimationPlayer"):
		var anim_player: AnimationPlayer = bullet_ui_instance.get_node("AnimationPlayer")
		if anim_player.has_animation("reload_bullet"):
			reload_anim_duration = anim_player.get_animation("reload_bullet").length
	
func _process(_delta: float) -> void:
	_reload_lever_action(reload_amount)
	
	if weapon_instance.current_state == weapon_instance.weapon_states.ATTACKING:
		weapon_instance.spawn_bullet(BULLET_SCENE_PATH, BULLET_DECAL_SCENE_PATH)
		
	# Re-emit signals from inner weapon instance
	weapon_instance.ui_bullet_fired.connect(func(index): emit_signal("ui_bullet_fired", index))
	weapon_instance.initiate_bullet_ui.connect(func(clip_amount): emit_signal("initiate_bullet_ui", clip_amount))
