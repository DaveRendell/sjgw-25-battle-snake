class_name InGameSettingsMenu extends CanvasLayer

signal finished

var player_input: PlayerInput
@onready var settings_page: SettingsPage = %SettingsPage

func _ready() -> void:
	settings_page.connect_player_input(player_input)

func _on_settings_page_finished() -> void:
	finished.emit()
