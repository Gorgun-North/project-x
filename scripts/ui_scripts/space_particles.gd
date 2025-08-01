extends GPUParticles2D

func  _ready() -> void:
	var get_process_material_instance: ParticleProcessMaterial = process_material
	
	get_process_material_instance.emission_box_extents.y = get_viewport().size.y
