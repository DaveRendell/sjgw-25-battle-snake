extends MarginContainer

@onready var your_score: Label = $Layout/YourScore
@onready var name_entry: Label = $Layout/NameEntry
@onready var player_input: PlayerInput = $PlayerInput
@onready var scoreboard: Scoreboard = $Scoreboard

var entered_name := ""
var current_character_index := 0
var _player_scoreboard_position := -1
var _player_score = 0
var current_character:
	get(): return char(65 + current_character_index) if entered_name.length() < 3 else ""

func _ready() -> void:
	_player_score = ScoreManager.get_score()
	your_score.text = "YOUR SCORE: %d" % _player_score
	
	var old_scores: Array[ScoreEntry] = ScoreManager.get_scoreboard()
	var board_position = old_scores.find_custom(func(entry): return entry.score < _player_score)
	
	if board_position == -1:
		name_entry.text = "BETTER LUCK NEXT TIME!"
		scoreboard.scores = old_scores
		player_input.accept_pressed.connect(func():
			get_tree().change_scene_to_file("res://ui/menu_scenes/main_menu.tscn"))
		return
	
	_player_scoreboard_position = board_position
	var new_scores = old_scores.slice(0, board_position)
	new_scores.append(ScoreEntry.new("   ", _player_score))
	new_scores.append_array(old_scores.slice(board_position + 1, 10))
	scoreboard.highlight_index = board_position
	scoreboard.scores = new_scores
	
	player_input.up_pressed.connect(_up_pressed)
	player_input.down_pressed.connect(_down_pressed)
	player_input.accept_pressed.connect(_accept_pressed)
	_update_label()

func _up_pressed() -> void:
	current_character_index = posmod(current_character_index + 1, 26)
	SfxManager.play_blip()
	_update_label()

func _down_pressed() -> void:
	current_character_index = posmod(current_character_index - 1, 26)
	SfxManager.play_blip()
	_update_label()

func _accept_pressed() -> void:
	SfxManager.play_blip()
	entered_name += current_character
	if entered_name.length() == 3:
		ScoreManager.record_score(entered_name, _player_score)
		scoreboard.scores = ScoreManager.get_scoreboard()
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://ui/menu_scenes/main_menu.tscn")
		
	_update_label()

func _update_label() -> void:
	var label_text = "ENTER YOUR NAME: %s%s" % [entered_name.substr(0, 3), current_character]
	name_entry.text = label_text
	
