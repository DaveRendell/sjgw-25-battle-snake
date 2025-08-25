extends HBoxContainer
@onready var player_1: Player = %Player1
@onready var player_2: Player = %Player2
@onready var camera_1: Camera2D = %Camera1
@onready var camera_2: Camera2D = %Camera2

@onready var sub_viewport: SubViewport = %SubViewport

@onready var sub_viewport_1: SubViewport = %SubViewport1
@onready var sub_viewport_2: SubViewport = %SubViewport2

func _ready() -> void:
	PlayerManager.players = [player_1, player_2]
	SpawnManager.start_game()
	player_1.remote_transform_2d.remote_path = camera_1.get_path()
	player_2.remote_transform_2d.remote_path = camera_2.get_path()
	
	sub_viewport_1.world_2d = sub_viewport.world_2d
	sub_viewport_2.world_2d = sub_viewport.world_2d
