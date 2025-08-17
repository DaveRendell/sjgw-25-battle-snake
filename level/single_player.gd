extends Control

@onready var player: Player = %Player
@onready var camera_2d: Camera2D = %Camera2D

func _ready() -> void:
	PlayerManager.players = [player]
	SpawnManager.start_game()
	MusicManager.start_stage_music()
	player.remote_transform_2d.remote_path = camera_2d.get_path()
