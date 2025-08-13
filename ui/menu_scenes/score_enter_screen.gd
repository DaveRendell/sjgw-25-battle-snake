extends MarginContainer

@onready var name_entry: Label = $Layout/NameEntry
@onready var player_input: PlayerInput = $PlayerInput

var entered_name := ""
var current_character_index := 0
var current_character:
	get(): return char(65 + current_character_index) if entered_name.length() < 3 else ""

func _ready() -> void:
	player_input.up_pressed.connect(_up_pressed)
	player_input.down_pressed.connect(_down_pressed)
	player_input.accept_pressed.connect(_accept_pressed)
	_update_label()

func _up_pressed() -> void:
	current_character_index = posmod(current_character_index + 1, 26)
	_update_label()

func _down_pressed() -> void:
	current_character_index = posmod(current_character_index - 1, 26)
	_update_label()

func _accept_pressed() -> void:
	entered_name += current_character
	if entered_name.length() == 3:
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://ui/menu_scenes/main_menu.tscn")
		
	_update_label()

func _update_label() -> void:
	var label_text = "ENTER YOUR NAME: %s%s" % [entered_name.substr(0, 3), current_character]
	name_entry.text = label_text
	
