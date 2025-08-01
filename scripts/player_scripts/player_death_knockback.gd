extends states
class_name player_death_knockback

@export var entity_instance: entity
@export var state_machine_controller_instance: state_machine_controller
@export var death_knockback_timer_duration: float = 1.0
@export var force: float = 500.0
@export var player_sprite: Sprite2D
@export var paused_camera_zoom: float = 0.5
@export var camera: Camera2D
@export var collision_box: CollisionShape2D

var normal_camera_zoom: float

var knockback_duration_instance: float
var knockback_finished: bool = true
var death_knockback_timer: float

var knockback_dir: Vector2

func _ready() -> void:
	death_knockback_timer = death_knockback_timer_duration
	if entity_instance:
		
		if entity_instance.got_hit.is_connected(_on_player_got_hit):
			return
		
		entity_instance.got_hit.connect(_on_player_got_hit)
		
func _physics_process(delta: float) -> void:
	if entity_instance is entity:
		if entity_instance.health <= 0:
			death_knockback_timer -= delta
			state_machine_controller_instance.current_state = state_machine_controller_instance.states_dict.get("death")
			
			var tween_x = get_tree().create_tween()
			var tween_y = get_tree().create_tween()
			
			tween_x.tween_property(camera, "zoom:x", paused_camera_zoom, death_knockback_timer_duration - 0.1)
			tween_y.tween_property(camera, "zoom:y", paused_camera_zoom, death_knockback_timer_duration - 0.1)
			
			if get_tree().get_first_node_in_group("death_menu").just_died == false:
				entity_instance.velocity = knockback_dir.normalized() * force
				Engine.time_scale = 0.5
				body.held_weapon.visible = false
			
			if death_knockback_timer <= 0.0:
				collision_box.disabled = true
				camera.zoom.x = paused_camera_zoom
				camera.zoom.y = paused_camera_zoom
				Engine.time_scale = 1.0
				body.velocity = Vector2.ZERO
				if is_instance_valid(player_sprite):
					player_sprite.queue_free()
				get_tree().get_first_node_in_group("death_menu").just_died = true
			

func _on_player_got_hit(_attacker: entity, hit_direction: Vector2, _knockback_force: float, _knockback_duration: float) -> void:
	
	if state_machine_controller_instance:
		knockback_dir = hit_direction
		
		
