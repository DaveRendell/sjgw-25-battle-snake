extends MarginContainer
@onready var player_input: PlayerInput = $PlayerInput

func _ready() -> void:
	player_input.accept_pressed.connect(func():
		SfxManager.play_blip()
		get_tree().change_scene_to_file("res://ui/menu_scenes/main_menu.tscn"))
