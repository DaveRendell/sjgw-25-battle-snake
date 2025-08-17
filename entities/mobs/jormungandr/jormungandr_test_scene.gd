extends Control
const CANNON_SEGMENT = preload("res://entities/player/segments/cannon_segment/cannon_segment.tscn")
const BOOSTER_SEGMENT = preload("res://entities/player/segments/booster_segment/booster_segment.tscn")
const FLAMETHROWER_SEGMENT = preload("res://entities/player/segments/flamethrower_segment/flamethrower_segment.tscn")
const TESLA_COIL_SEGMENT = preload("res://entities/player/segments/tesla_coil_segment/tesla_coil_segment.tscn")
const MAGNET_SEGMENT = preload("res://entities/player/segments/magnet_segment/magnet_segment.tscn")

@onready var player: Player = %Player
@onready var camera_2d: Camera2D = %Camera2D

func _ready() -> void:
	PlayerManager.players = [player]
	SpawnManager._stages[SpawnManager._stages.size() - 2].time = 5.0
	SpawnManager.start_game(SpawnManager._stages.size() - 2)
	MusicManager.start_stage_music()
	player.remote_transform_2d.remote_path = camera_2d.get_path()
	for i in 5:
		player.add_segment(CANNON_SEGMENT)
	for i in 4:
		player.add_segment(BOOSTER_SEGMENT)
	for i in 3:
		player.add_segment(FLAMETHROWER_SEGMENT)
	for i in 3:
		player.add_segment(TESLA_COIL_SEGMENT)
	for i in 1:
		player.add_segment(MAGNET_SEGMENT)
