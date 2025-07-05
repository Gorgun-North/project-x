extends states
class_name enemy_idle

var target: CharacterBody2D

func Entered():
	target = get_tree().get_first_node_in_group("Player")
	if target == null:
		push_error("Could not find player in 'player' group!")

func Update(_delta):
	if target:
		Transitioned.emit(self, "Move")
		
