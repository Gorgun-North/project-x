extends Node
class_name handle_mouse_cursor

var is_clicking := false

func _input(event):
	if get_tree().paused or get_tree().get_first_node_in_group("Player").health <= 0.0:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not is_clicking:
				change_cursor_click_temporarily()

func _process(_delta: float) -> void:
	if get_tree().paused or get_tree().get_first_node_in_group("Player").health <= 0.0:
		if not is_clicking:
			Input.set_custom_mouse_cursor(load("res://assets/ui_elements/menu_mouse_01.png"))
	else:
		Input.set_custom_mouse_cursor(load("res://assets/ui_elements/crosshair.png"))

func change_cursor_click_temporarily():
	is_clicking = true
	Input.set_custom_mouse_cursor(load("res://assets/ui_elements/menu_mouse_02.png"))

	var timer := Timer.new()
	timer.wait_time = 0.1
	timer.one_shot = true
	add_child(timer)
	timer.start()

	await timer.timeout

	Input.set_custom_mouse_cursor(load("res://assets/ui_elements/menu_mouse_01.png"))
	timer.queue_free()
	is_clicking = false
