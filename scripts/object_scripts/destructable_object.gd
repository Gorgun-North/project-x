extends entity

@export var mass: float
var knockback_duration_instance: float
var actual_knockback: float 
var hit_dir: Vector2

var knockback_finished_flag: bool = true
signal knockback_finished

func _physics_process(delta: float) -> void:
	self.velocity = hit_dir.normalized() * actual_knockback
	
	if knockback_duration_instance <= 0.0:
		self.velocity = Vector2.ZERO
		
		if not knockback_finished_flag:
			knockback_finished_flag = true
			knockback_finished.emit()
		
	elif knockback_duration_instance > 0.0:
		knockback_duration_instance -= delta
		knockback_finished_flag = false
		
	self.move_and_slide()

func _ready() -> void:
	got_hit.connect(_on_got_hit)
	knockback_finished.connect(_on_knockback_finished)
	
	
func _on_got_hit(hit_direction: Vector2, knockback_force: float, knockback_duration: float):
	actual_knockback = knockback_force - mass
		
	knockback_duration_instance = knockback_duration
	hit_dir = hit_direction

func _on_knockback_finished():
	if health > 0.0:
		rebake_on_movement()
	
func _exit_tree() -> void:
	if navobstacle:
		navobstacle.affect_navigation_mesh = false
		navobstacle.carve_navigation_mesh = false
		navobstacle.queue_free()
	
	rebake_on_movement()
