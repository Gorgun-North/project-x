extends Node
class_name mouse_look

@export var body: CharacterBody2D
@export var sprite2D: Sprite2D
var deadzone: float = 0.15

var mouse_look_mode: String = "mouse"

enum AimMode {MOUSE, CONTROLLER}

func _physics_process(_delta: float) -> void:
	sprite2D.global_position = body.global_position
	

func _input(event: InputEvent) -> void:
	#Checks if the body is selected and if so, lets the characterbody2d look at the mouse
	if body:
		
		if event is InputEventJoypadMotion:
			mouse_look_mode = "controller"
			var stick: Vector2 = Input.get_vector("RTstick_left", "RTstick_right",
												  "RTstick_up", "RTstick_down")
			
			if stick.length() > deadzone:
				body.look_at(body.global_position + stick.normalized() * 100)
				$"../../reload_ui_timer_placeholder".global_rotation = 0.0
		elif event is InputEventMouseMotion:
			mouse_look_mode = "mouse"
			var mouse_pos = body.get_global_mouse_position()
			body.look_at(mouse_pos)
			$"../../reload_ui_timer_placeholder".global_rotation = 0.0
	else:
		print("body is not selected, attach it to this node: ", self)
		
