extends Control

@onready var player: Player = %Player
@onready var camera_2d: Camera2D = %Camera2D

var _hud: Hud

func _ready() -> void:
	PlayerManager.players = [player]
	SpawnManager.start_game()
	MusicManager.start_stage_music()
	ScoreManager.reset_score()
	player.remote_transform_2d.remote_path = camera_2d.get_path()
	_hud = get_tree().get_first_node_in_group("hud")
	player.destroyed.connect(_game_over)

func _game_over() -> void:
	await _hud.game_over()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://ui/menu_scenes/score_enter_screen.tscn")
