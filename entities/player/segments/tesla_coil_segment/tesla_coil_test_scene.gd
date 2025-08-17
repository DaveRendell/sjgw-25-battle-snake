extends Control
const TESLA_COIL_SEGMENT = preload("res://entities/player/segments/tesla_coil_segment/tesla_coil_segment.tscn")
@onready var player: Player = %Player
@onready var camera_2d: Camera2D = %Camera2D

func _ready() -> void:
	PlayerManager.players = [player]
	SpawnManager.start_custom(SpawnProfile.new().with_spawn_timeout(1.0).with_swarm_probability(0.5))
	player.remote_transform_2d.remote_path = camera_2d.get_path()
	for i in 1:
		player.add_segment(TESLA_COIL_SEGMENT)
