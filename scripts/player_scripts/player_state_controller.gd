extends Node

@export var characterbody: CharacterBody2D #Gain access to the characterbody2D functions
var current_state : player_states #Make the player state script an object
var states : Dictionary = {} #Get all states as a dictionary

@export var initial_state : player_states


func _ready() -> void:
	#Initialize all available states and save them in the dictionary
	for child in get_children():
		if child is player_states:
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
	print(characterbody.velocity, " : ", current_state)

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

#Signal for when the state transitiones to another.
func on_child_transitioned(state: player_states, new_state_name: String) -> void:
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
		
	new_state.Entered()
	
	current_state = new_state
