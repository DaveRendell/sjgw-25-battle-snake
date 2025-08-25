extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	color_rect.visible = SettingsManager.screen_filter
	SettingsManager.screen_filter_changed.connect(func(value: bool):
		color_rect.visible = value)
	_set_screen_size()
	SettingsManager.aspect_ratio_changed.connect(_set_screen_size.unbind(1))

func _set_screen_size() -> void:
	var shader_material: ShaderMaterial = color_rect.material
	match SettingsManager.aspect_ratio:
		SettingsManager.AspectRatio.RATIO_16_9:
			shader_material.set_shader_parameter("scanline_count", 180)
		SettingsManager.AspectRatio.RATIO_16_10:
			shader_material.set_shader_parameter("scanline_count", 200)
