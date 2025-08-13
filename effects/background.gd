extends TextureRect

@export var speed: float = 1.0

var _offset = 0.0

func _physics_process(delta: float) -> void:
	_offset += delta * speed
	
	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("polarAngle", _offset)
