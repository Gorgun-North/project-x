extends Node

@export var body: entity
@export var sprite2d: Sprite2D
@export var shadow_anim_player: AnimationPlayer

func _physics_process(_delta: float) -> void:
	sprite2d.global_position = body.global_position
	
	if body.velocity != Vector2.ZERO:
		shadow_anim_player.play("shadow_move")
	else:
		shadow_anim_player.play("RESET")
