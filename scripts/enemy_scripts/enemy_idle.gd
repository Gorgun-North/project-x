extends states
class_name enemy_idle

var target: CharacterBody2D
@export var state_machine_controller_instance: state_machine_controller

func Entered():
	target = get_tree().get_first_node_in_group("Player")
	if target == null:
		push_error("Could not find player in 'player' group!")

func Update(_delta):
	if target:
		Transitioned.emit(self, "Move")
		
func _process(_delta: float) -> void:
	if get_tree().get_first_node_in_group("Player").health <= 0.0:
		state_machine_controller_instance.current_state = state_machine_controller_instance.states_dict.get("idle")
		body.velocity = Vector2.ZERO
