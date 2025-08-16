extends Control
const FLAMETHROWER_SEGMENT = preload("res://entities/player/segments/flamethrower_segment/flamethrower_segment.tscn")

@onready var player: Player = %Player
@onready var camera_2d: Camera2D = %Camera2D

func _ready() -> void:
	PlayerManager.players = [player]
	SpawnManager.start_game()
	player.remote_transform_2d.remote_path = camera_2d.get_path()
	for i in 5:
		player.add_segment(FLAMETHROWER_SEGMENT)
