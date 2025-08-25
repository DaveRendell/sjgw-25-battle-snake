extends Control
@onready var settings_page: SettingsPage = $SettingsPage

func _ready() -> void:
	settings_page.connect_player_input(InputManager.p1_input)

func _close() -> void:
	get_tree().change_scene_to_file("res://ui/menu_scenes/main_menu.tscn")
