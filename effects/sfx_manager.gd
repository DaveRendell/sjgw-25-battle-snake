extends Node
const PICKUP: AudioStreamWAV = preload("res://effects/sounds/pickup.wav")
const EXPLOSION = preload("res://effects/sounds/explosion.wav")
const LEVEL_UP = preload("res://effects/sounds/level_up.wav")

var _pickup_player = AudioStreamPlayer.new()
var _explosion_player = AudioStreamPlayer.new()
var _level_up_player = AudioStreamPlayer.new()

func _ready() -> void:
	_pickup_player.max_polyphony = 4
	_pickup_player.volume_linear = 0.5
	_pickup_player.stream = PICKUP
	add_child(_pickup_player)
	
	_explosion_player.max_polyphony = 2
	_explosion_player.volume_linear = 0.5
	_explosion_player.stream = EXPLOSION
	add_child(_explosion_player)
	
	_level_up_player.max_polyphony = 1
	_level_up_player.volume_linear = 0.4
	_level_up_player.stream = LEVEL_UP
	add_child(_level_up_player)

func play_pickup() -> void:
	_pickup_player.play()

func play_explosion() -> void:
	_explosion_player.play()

func play_level_up() -> void:
	_level_up_player.play()
