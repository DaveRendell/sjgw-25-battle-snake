extends Node

const STAGE_MUSIC = preload("res://music/Chippy Music 12.mp3")
const BOSS_MUSIC = preload("res://music/Chippy Music 16.mp3")

var _player = AudioStreamPlayer.new()

func _ready() -> void:
	_player.max_polyphony = 1
	_player.volume_linear = SettingsManager.main_volume * SettingsManager.sfx_volume / 2500.0
	SettingsManager.main_volume_changed.connect(_set_volume.unbind(1))
	SettingsManager.music_volume_changed.connect(_set_volume.unbind(1))
	add_child(_player)
	
	process_mode = Node.PROCESS_MODE_ALWAYS

func _set_volume() -> void:
	_player.volume_linear = SettingsManager.main_volume * SettingsManager.sfx_volume / 2500.0

func start_stage_music() -> void:
	if _player.playing: await stop_music()
	_player.volume_linear = 0.5
	_player.stream = STAGE_MUSIC
	_player.play()

func start_boss_music() -> void:
	if _player.playing: await stop_music()
	_player.volume_linear = 0.5
	_player.stream = BOSS_MUSIC
	_player.play()

func stop_music(fade_out_time: float = 3.0) -> void:
	if not _player.playing: return
	var fade_out_tween = get_tree().create_tween()
	fade_out_tween.tween_property(_player, "volume_linear", 0.0, fade_out_time)
	await fade_out_tween.finished
	_player.stop()
