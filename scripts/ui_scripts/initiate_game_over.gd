extends Node

var player: entity
@export var gameover_hud: Control

var game_over_text: Array = [
	"Looks like you're out till lunch...",
	"No gamer time for you",
	"Skill issue",
	"Why don't you try again :)"
]

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	rng.randomize()
	var get_random_index = randi_range(0, game_over_text.size() - 1)
	$"../PanelContainer/VBoxContainer/TextEdit".text = game_over_text[get_random_index]
func _process(_delta: float) -> void:
	if player:
		if player.health <= 0:
			get_tree().paused = true
			gameover_hud.show()
			$"../PanelContainer/VBoxContainer/Restart".grab_focus()
