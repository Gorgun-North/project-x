extends ColorRect
class_name lamp_lighting

func _ready() -> void:
	self.show()
	
func _process(_delta: float) -> void:
	var light_positions = _get_light_positions()
	self.material.set_shader_parameter("number_of_lights", light_positions.size())
	self.material.set_shader_parameter("lights", light_positions)
	
func _get_light_positions():
	return get_tree().get_nodes_in_group("basic_lamp").map(
		func(light: Node2D):
			return light.get_global_transform_with_canvas().origin
	)
