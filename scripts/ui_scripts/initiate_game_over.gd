extends Node

var player: entity
@export var gameover_hud: Control
@export var anim_player: AnimationPlayer

var initiate_death_screen_flag: bool = false

var game_over_text: Array = [
	"Looks like you're out till lunch...",
	"No gamer time for you",
	"Skill issue",
	"Why don't you try again :)",
	"Oh you almost had him (probably)",
	"Bro you are on that googoogaagaa mentality, how about you stop that",
	"You play like a game journalist"
]

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	rng.randomize()
	var get_random_index = randi_range(0, game_over_text.size() - 1)
	$"../Control/Sprite2D/TextEdit".text = game_over_text[get_random_index]
	
func _process(_delta: float) -> void:
	if gameover_hud.just_died == false:
		initiate_death_screen_flag = false
	
	if initiate_death_screen_flag == true:
		return
	
	if player:
		if gameover_hud.just_died == true:
			gameover_hud.show()
			gameover_hud.is_in_death_screen = true
			anim_player.play_backwards("you_died")
			await anim_player.animation_finished
			initiate_death_screen_flag = true
			
			$"../Control/Restart".grab_focus()
