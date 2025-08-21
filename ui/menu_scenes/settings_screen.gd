extends Control

func _close() -> void:
	get_tree().change_scene_to_file("res://ui/menu_scenes/main_menu.tscn")
