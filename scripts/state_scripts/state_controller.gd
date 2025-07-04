extends Node

@export var characterbody: CharacterBody2D #Gain access to the characterbody2D functions
var current_state : states #Make the player state script an object
var states : Dictionary = {} #Get all states as a dictionary

@export var initial_state : states


func _ready() -> void:
	#Initialize all available states and save them in the dictionary
	for child in get_children():
		if child is states:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
			
			child.body = characterbody
			
	if initial_state:
		initial_state.Entered()
		current_state = initial_state
			
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)
		
	characterbody.move_and_slide()
	#print(states)

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

#Signal for when the state transitiones to another.
func on_child_transitioned(state: states, new_state_name: String) -> void:
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Entered()
	
	current_state = new_state
