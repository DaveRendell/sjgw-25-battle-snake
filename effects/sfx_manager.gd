extends Node
const PICKUP: AudioStreamWAV = preload("res://effects/sounds/pickup.wav")
const EXPLOSION = preload("res://effects/sounds/explosion.wav")
const LEVEL_UP = preload("res://effects/sounds/level_up.wav")
const BLIP = preload("res://effects/sounds/blip.wav")
const FLAMES = preload("res://effects/sounds/flames.wav")
const SHOOT = preload("res://effects/sounds/shoot.wav")
const MOB_HURT = preload("res://effects/sounds/mob_hurt.wav")
const PLAYER_HURT = preload("res://effects/sounds/player_hurt.wav")
const THUNDER = preload("res://effects/sounds/thunder.wav")


var _pickup_player = AudioStreamPlayer.new()
var _explosion_player = AudioStreamPlayer.new()
var _level_up_player = AudioStreamPlayer.new()
var _blip_player = AudioStreamPlayer.new()
var _flames_player = AudioStreamPlayer.new()
var _shoot_player = AudioStreamPlayer.new()
var _mob_oof_player = AudioStreamPlayer.new()
var _player_oof_player = AudioStreamPlayer.new()
var _thunder_player = AudioStreamPlayer.new()

func _ready() -> void:
	_pickup_player.max_polyphony = 2
	_pickup_player.volume_linear = 0.3
	_pickup_player.stream = PICKUP
	add_child(_pickup_player)
	
	_explosion_player.max_polyphony = 2
	_explosion_player.volume_linear = 0.2
	_explosion_player.stream = EXPLOSION
	add_child(_explosion_player)
	
	_level_up_player.max_polyphony = 1
	_level_up_player.volume_linear = 0.1
	_level_up_player.stream = LEVEL_UP
	add_child(_level_up_player)
	
	_blip_player.max_polyphony = 1
	_blip_player.volume_linear = 0.1
	_blip_player.stream = BLIP
	add_child(_blip_player)
	
	_flames_player.max_polyphony = 1
	_flames_player.volume_linear = 0.1
	_flames_player.stream = FLAMES
	add_child(_flames_player)
	
	_shoot_player.max_polyphony = 1
	_shoot_player.volume_linear = 0.1
	_shoot_player.stream = SHOOT
	add_child(_shoot_player)
	
	_mob_oof_player.max_polyphony = 1
	_mob_oof_player.volume_linear = 0.1
	_mob_oof_player.stream = MOB_HURT
	add_child(_mob_oof_player)
	
	_player_oof_player.max_polyphony = 1
	_player_oof_player.volume_linear = 0.4
	_player_oof_player.stream = PLAYER_HURT
	add_child(_player_oof_player)
	
	_thunder_player.max_polyphony = 1
	_thunder_player.volume_linear = 0.1
	_thunder_player.stream = THUNDER
	add_child(_thunder_player)

func play_pickup() -> void:
	_pickup_player.play()

func play_explosion() -> void:
	_explosion_player.play()

func play_level_up() -> void:
	_level_up_player.play()

func play_blip() -> void:
	_blip_player.play()

func play_flames() -> void:
	_flames_player.play()

func play_shoot() -> void:
	_shoot_player.play()

func play_mob_oof() -> void:
	_mob_oof_player.play()

func play_player_oof() -> void:
	_player_oof_player.play()

func play_thunder() -> void:
	_thunder_player.play()
