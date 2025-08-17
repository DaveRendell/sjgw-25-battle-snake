extends MarginContainer

@onready var _options: VBoxContainer = $Options

@onready var _1p_game_button: Button = $"Options/1pGameButton"
@onready var _2p_game_button: Button = $"Options/2pGameButton"
@onready var _scoreboard_button: Button = $Options/ScoreboardButton
@onready var _settings_button: Button = $Options/SettingsButton

@onready var _selected_indicator: Label = $"Options/1pGameButton/SelectedIndicator"
@onready var _player_input: PlayerInput = $PlayerInput

var _selected_item_index := 0

func _ready() -> void:
	_1p_game_button.pressed.connect(_1p_game_pressed)
	_2p_game_button.pressed.connect(_2p_game_pressed)
	_scoreboard_button.pressed.connect(_scoreboard_pressed)
	_settings_button.pressed.connect(_settings_pressed)
	
	_player_input.up_pressed.connect(_up_pressed)
	_player_input.down_pressed.connect(_down_pressed)
	_player_input.accept_pressed.connect(func():
		var selected_option: Button = _options.get_child(_selected_item_index)
		SfxManager.play_blip()
		selected_option.pressed.emit())
	
func _down_pressed() -> void:
	_selected_item_index = posmod(_selected_item_index + 1, _options.get_child_count())
	SfxManager.play_blip()
	_update_selected_indicator()

func _up_pressed() -> void:
	_selected_item_index = posmod(_selected_item_index - 1, _options.get_child_count())
	SfxManager.play_blip()
	_update_selected_indicator()

func _update_selected_indicator() -> void:
	_selected_indicator.reparent(_options.get_child(_selected_item_index), false)

# Options

func _1p_game_pressed() -> void:
	get_tree().change_scene_to_file("res://level/single_player.tscn")

func _2p_game_pressed() -> void:
	get_tree().change_scene_to_file("res://level/multi_player.tscn")

func _scoreboard_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/menu_scenes/scoreboard_page.tscn")

func _settings_pressed() -> void:
	print("Settings selected")
