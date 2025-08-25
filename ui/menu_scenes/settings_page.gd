class_name SettingsPage extends MarginContainer

signal finished

enum SelectedRow {
	MAIN_VOLUME = 0,
	MUSIC_VOLUME = 1,
	SFX_VOLUME = 2,
	BG_ANIMATION = 3,
	SCREEN_FILTER = 4,
	ASPECT_RATIO = 5,
	SCREEN_SCALE = 6,
	CLOSE = 7,
}

var _selected_index: int = 0:
	set(value):
		_selected_index = value
		_update_selector()
var _option_count: int

@onready var _layout: VBoxContainer = %Layout
@onready var _selected_indicator: Label = %SelectedIndicator

@onready var _main_volume_slider: HSlider = %MainVolumeSlider
@onready var _music_volume_slider: HSlider = %MusicVolumeSlider
@onready var _sfx_volume_slider: HSlider = $Layout/SfxVolume/SfxVolumeSlider
@onready var _bg_animation_checkbox: CheckBox = %BgAnimationCheckbox
@onready var _screen_filter_checkbox: CheckBox = %ScreenFilterCheckbox
@onready var _aspect_ratio_options: Label = %AspectRatioOptions
@onready var _screen_scale_options: Label = $Layout/ScreenScale/ScreenScaleOptions


func _ready() -> void:
	
	_option_count = _layout.get_child_count() - 1
	
	_main_volume_slider.value = SettingsManager.main_volume
	SettingsManager.main_volume_changed.connect(func(value: float):
		_main_volume_slider.value = value)
	
	_music_volume_slider.value = SettingsManager.music_volume
	SettingsManager.music_volume_changed.connect(func(value: float):
		_music_volume_slider.value = value)
	
	_sfx_volume_slider.value = SettingsManager.sfx_volume
	SettingsManager.sfx_volume_changed.connect(func(value: float):
		_sfx_volume_slider.value = value)
	
	_bg_animation_checkbox.button_pressed = SettingsManager.background_animation
	SettingsManager.background_animation_changed.connect(func(value: bool):
		_bg_animation_checkbox.button_pressed = value)
	
	_screen_filter_checkbox.button_pressed = SettingsManager.screen_filter
	SettingsManager.screen_filter_changed.connect(func(value: bool):
		_screen_filter_checkbox.button_pressed = value)
	
	_update_aspect_ratio_options(SettingsManager.aspect_ratio)
	SettingsManager.aspect_ratio_changed.connect(_update_aspect_ratio_options)
	
	_update_screen_scale_options(SettingsManager.screen_scale)
	SettingsManager.screen_scale_changed.connect(_update_screen_scale_options)

func connect_player_input(player_input: PlayerInput) -> void:
	player_input.up_pressed.connect(_up_pressed)
	player_input.down_pressed.connect(_down_pressed)
	player_input.left_pressed.connect(_left_pressed)
	player_input.right_pressed.connect(_right_pressed)
	player_input.accept_pressed.connect(_accept_pressed)
	player_input.cancel_pressed.connect(_cancel_pressed)
	

func _update_selector() -> void:
	var selected_option: Node = _layout.get_child(_selected_index + 1)
	_selected_indicator.reparent(selected_option, false)

func _up_pressed() -> void:
	_selected_index = posmod(_selected_index - 1, _option_count)
	SfxManager.play_blip()

func _down_pressed() -> void:
	_selected_index = posmod(_selected_index + 1, _option_count)
	SfxManager.play_blip()

func _left_pressed() -> void:
	match _selected_index:
		SelectedRow.MAIN_VOLUME: SettingsManager.main_volume -= 10.0
		SelectedRow.MUSIC_VOLUME: SettingsManager.music_volume -= 10.0
		SelectedRow.SFX_VOLUME: SettingsManager.sfx_volume -= 10.0
		SelectedRow.ASPECT_RATIO: SettingsManager.aspect_ratio -= 1
		SelectedRow.SCREEN_SCALE: SettingsManager.screen_scale -= 1
		_: return
	SfxManager.play_blip()

func _right_pressed() -> void:
	match _selected_index:
		SelectedRow.MAIN_VOLUME: SettingsManager.main_volume += 10.0
		SelectedRow.MUSIC_VOLUME: SettingsManager.music_volume += 10.0
		SelectedRow.SFX_VOLUME: SettingsManager.sfx_volume += 10.0
		SelectedRow.ASPECT_RATIO: SettingsManager.aspect_ratio += 1
		SelectedRow.SCREEN_SCALE: SettingsManager.screen_scale += 1
		_: return
	SfxManager.play_blip()

func _accept_pressed() -> void:
	match _selected_index:
		SelectedRow.BG_ANIMATION:
			SettingsManager.background_animation = !SettingsManager.background_animation
		SelectedRow.SCREEN_FILTER:
			SettingsManager.screen_filter = !SettingsManager.screen_filter
		SelectedRow.CLOSE:
			finished.emit()
		_: return
	SfxManager.play_blip()

func _cancel_pressed() -> void:
	finished.emit()

func _update_aspect_ratio_options(value: SettingsManager.AspectRatio) -> void:
	match value:
		SettingsManager.AspectRatio.RATIO_16_9: _aspect_ratio_options.text =  "◀ 16:9  ▶"
		SettingsManager.AspectRatio.RATIO_16_10: _aspect_ratio_options.text = "◀ 16:10 ▶"

func _update_screen_scale_options(value: int) -> void:
	_screen_scale_options.text = "◀  %dX   ▶" % value
