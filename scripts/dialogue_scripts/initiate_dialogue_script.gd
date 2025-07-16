extends Node

@export var get_dialogue: String

func _ready() -> void:
	Dialogic.start(get_dialogue)
	
