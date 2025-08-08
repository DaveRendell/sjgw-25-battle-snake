extends MarginContainer

@onready var _options: VBoxContainer = $Options

@onready var _1p_game_button: Button = $"Options/1pGameButton"
@onready var _2p_game_button: Button = $"Options/2pGameButton"
@onready var _settings_button: Button = $Options/SettingsButton

@onready var selected_indicator: Label = $"Options/1pGameButton/SelectedIndicator"

var _selected_item_index := 0

func _ready() -> void:
	_1p_game_button.pressed.connect(_1p_game_pressed)
	_2p_game_button.pressed.connect(_2p_game_pressed)
	_settings_button.pressed.connect(_settings_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"): _down_pressed()
	if event.is_action_pressed("ui_up"): _up_pressed()
	if event.is_action_pressed("ui_accept"):
		var selected_option: Button = _options.get_child(_selected_item_index)
		selected_option.pressed.emit()
	
func _down_pressed() -> void:
	_selected_item_index = posmod(_selected_item_index + 1, _options.get_child_count())
	_update_selected_indicator()

func _up_pressed() -> void:
	_selected_item_index = posmod(_selected_item_index - 1, _options.get_child_count())
	_update_selected_indicator()

func _update_selected_indicator() -> void:
	selected_indicator.reparent(_options.get_child(_selected_item_index), false)

func _1p_game_pressed() -> void:
	print("1P Game selected")

func _2p_game_pressed() -> void:
	print("2P Game selected")

func _settings_pressed() -> void:
	print("Settings selected")
