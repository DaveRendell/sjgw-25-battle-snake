extends Node

enum AspectRatio {
	RATIO_16_9 = 0,
	RATIO_16_10 = 1,
}

signal main_volume_changed(value: float)
signal music_volume_changed(value: float)
signal sfx_volume_changed(value: float)
signal background_animation_changed(value: bool)
signal screen_filter_changed(value: bool)
signal aspect_ratio_changed(value: AspectRatio)
signal screen_scale_changed(value: int)

func _ready() -> void:
	_load()

var main_volume: float = 50.0:
	set(value):
		main_volume = clamp(value, 0.0, 100.0)
		main_volume_changed.emit(main_volume)
		_save()
var music_volume: float = 50.0:
	set(value):
		music_volume = clamp(value, 0.0, 100.0)
		music_volume_changed.emit(music_volume)
		_save()
var sfx_volume: float = 50.0:
	set(value):
		sfx_volume = clamp(value, 0.0, 100.0)
		sfx_volume_changed.emit(sfx_volume)
		_save()

var aspect_ratio: AspectRatio = AspectRatio.RATIO_16_9:
	set(value):
		aspect_ratio = posmod(value, AspectRatio.size())
		aspect_ratio_changed.emit(aspect_ratio)
		_update_screen_size()
		_save()

var background_animation: bool = true:
	set(value):
		background_animation = value
		background_animation_changed.emit(background_animation)
		_save()

var screen_filter: bool = true:
	set(value):
		screen_filter = value
		screen_filter_changed.emit(screen_filter)
		_save()

var screen_scale: int = 2:
	set(value):
		screen_scale = clampi(value, 1, 6)
		screen_scale_changed.emit(screen_scale)
		_update_screen_size()
		_save()

func _update_screen_size() -> void:
	match aspect_ratio:
		AspectRatio.RATIO_16_9:
			get_tree().root.size = screen_scale * Vector2i(640, 360)
		AspectRatio.RATIO_16_10:
			get_tree().root.size = screen_scale * Vector2i(640, 400)
	get_tree().root.content_scale_factor = screen_scale
	get_tree().root.content_scale_size = get_tree().root.size

func _save() -> void:
	var settings_file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	var settings_json = JSON.stringify({
		"version": 1,
		"main_volume": main_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"background_animation": background_animation,
		"screen_filter": screen_filter,
		"aspect_ratio": aspect_ratio,
		"screen_scale": screen_scale,
	})
	settings_file.store_line(settings_json)

func _load() -> void:
	var settings_file = FileAccess.open("user://settings.json", FileAccess.READ)
	
	if settings_file == null:
		return
	
	var settings_json = settings_file.get_line()
	var saved_settings: Dictionary = JSON.parse_string(settings_json)
	
	if saved_settings.has("main_volume"):
		main_volume = saved_settings["main_volume"]
	if saved_settings.has("music_volume"):
		music_volume = saved_settings["music_volume"]
	if saved_settings.has("sfx_volume"):
		sfx_volume = saved_settings["sfx_volume"]
	if saved_settings.has("background_animation"):
		background_animation = saved_settings["background_animation"]
	if saved_settings.has("screen_filter"):
		screen_filter = saved_settings["screen_filter"]
	if saved_settings.has("aspect_ratio"):
		aspect_ratio = saved_settings["aspect_ratio"]
	if saved_settings.has("screen_scale"):
		aspect_ratio = saved_settings["screen_scale"]
	
