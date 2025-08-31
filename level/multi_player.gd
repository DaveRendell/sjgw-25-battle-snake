extends HBoxContainer
const EGG = preload("res://entities/player/egg.tscn")
const PLAYER = preload("res://entities/player/player.tscn")

@onready var player_1: Player = %Player1
@onready var player_2: Player = %Player2
@onready var camera_1: Camera2D = %Camera1
@onready var camera_2: Camera2D = %Camera2
@onready var sub_viewport: SubViewport = %SubViewport
@onready var hud_mp: HudMp = $HudMp

@onready var sub_viewport_1: SubViewport = %SubViewport1
@onready var sub_viewport_2: SubViewport = %SubViewport2

@onready var _pointer_layer_p1: PointerLayer = $TextureRect/SubViewport1/PointerLayer
@onready var _pointer_layer_p2: PointerLayer = $TextureRect2/SubViewport2/PointerLayer

func _ready() -> void:
	ScoreManager.reset_score()
	PlayerManager.players = [player_1, player_2]
	SpawnManager.start_game()
	player_1.remote_transform_2d.remote_path = camera_1.get_path()
	player_2.remote_transform_2d.remote_path = camera_2.get_path()
	
	sub_viewport_1.world_2d = sub_viewport.world_2d
	sub_viewport_2.world_2d = sub_viewport.world_2d
	
	player_1.destroyed.connect(_on_player_destroyed.bind(player_1))
	player_2.destroyed.connect(_on_player_destroyed.bind(player_2))

func _on_player_destroyed(player: Player) -> void:
	if PlayerManager.players.is_empty():
		_game_over()
		return
	
	var player_id = player.player_id
	var player_node_name = player.name
	var player_position = player.position
	var camera = camera_1 if player_id == 1 else camera_2
	
	var egg = EGG.instantiate()
	egg.position = player_position
	egg.hatched.connect(func():
		var new_player = PLAYER.instantiate()
		new_player.player_id = player_id
		new_player.name = player_node_name
		new_player.position = player_position
		
		sub_viewport.add_child.call_deferred(new_player)
		if player_id == 1:
			hud_mp.connect_player1(new_player)
		else:
			hud_mp.connect_player2(new_player)
		await new_player.ready
		
		PlayerManager.players.append(new_player)
		new_player.remote_transform_2d.remote_path = camera.get_path()
		new_player.make_invulnerable(3.0)
		new_player.destroyed.connect(_on_player_destroyed.bind(new_player))
		
		if player_id == 1:
			_pointer_layer_p1.player = new_player
			_pointer_layer_p2.target = new_player
		else:
			_pointer_layer_p2.player = new_player
			_pointer_layer_p1.target = new_player
		)
	player.add_sibling.call_deferred(egg)
	
	if player_id == 1:
		_pointer_layer_p2.target = egg
	else:
		_pointer_layer_p1.target = egg

func _game_over() -> void:
	await hud_mp.game_over()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://ui/menu_scenes/score_enter_screen.tscn")
