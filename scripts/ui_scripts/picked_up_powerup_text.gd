extends Node2D
class_name powerup_text

@export var popup_text_timer_duration: float = 3.0

var popup_text_timer: float
var text_tween: Tween
var root_tween: Tween

var set_rotation_amount: float

var rng = RandomNumberGenerator.new()

func move_text() -> void:   
	var set_move_amount: float = rng.randf_range(30, 75)
	var tween_end_position: float = self.position.y - set_move_amount
	
	root_tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	text_tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	root_tween.tween_property(self, "position:y", tween_end_position, popup_text_timer_duration)
	text_tween.tween_property($Label, "rotation_degrees", set_rotation_amount, popup_text_timer_duration)


func _ready() -> void:
	popup_text_timer = popup_text_timer_duration
	set_rotation_amount = rng.randf_range(-30, 30)

func set_picked_up_powerup_event(text: String):
	$Label.text = text
	
func _process(delta: float) -> void:
	move_text()
	popup_text_timer -= delta
	
	if popup_text_timer <= 0.0:
		self.queue_free()
	
	
