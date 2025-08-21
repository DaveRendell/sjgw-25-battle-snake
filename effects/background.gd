extends TextureRect

@export var speed: float = 1.0

var _offset = 0.0

func _ready() -> void:
	_set_screen_size()
	SettingsManager.aspect_ratio_changed.connect(_set_screen_size.unbind(1))

func _set_screen_size() -> void:
	match SettingsManager.aspect_ratio:
		SettingsManager.AspectRatio.RATIO_16_9:
			prints("16-9", size)
			size = Vector2i(640, 360)
			prints(size)
		SettingsManager.AspectRatio.RATIO_16_10:
			prints("16-10", size)
			size = Vector2i(640, 400)
			prints(size)

func _physics_process(delta: float) -> void:
	_offset += delta * speed
	
	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("polarAngle", _offset)
