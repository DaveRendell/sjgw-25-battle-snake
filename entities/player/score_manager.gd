extends Node

signal score_changed(score: int)

var _default_scores: Array[ScoreEntry] = [
	ScoreEntry.new("ABC", 3000),
	ScoreEntry.new("XYZ", 2500),
	ScoreEntry.new("TIE", 2000),
	ScoreEntry.new("ABC", 2500),
	ScoreEntry.new("XYZ", 2250),
	ScoreEntry.new("TIE", 2000),
	ScoreEntry.new("ABC", 1750),
	ScoreEntry.new("XYZ", 1500),
	ScoreEntry.new("TIE", 1000),
	ScoreEntry.new("TIE", 200),
]

var _score: int = 0:
	set(value):
		_score = value
		score_changed.emit(_score)
var _scoreboard: Array[ScoreEntry] = []

func _ready() -> void:
	read_scores_from_file()

func increase_score(amount: int) -> void:
	_score += amount

func reset_score() -> void:
	_score = 0

func get_score() -> int:
	return _score

func record_score(player_name: String, score: int) -> void:
	_scoreboard.append(ScoreEntry.new(player_name, score))
	_scoreboard.sort_custom(func(a, b): return b.score < a.score)
	_scoreboard = _scoreboard.slice(0, 10)
	write_scores_to_file()

func get_scoreboard() -> Array[ScoreEntry]:
	return _scoreboard

func read_scores_from_file() -> void:
	var score_file = FileAccess.open("user://scoreboard.json", FileAccess.READ)
	
	if score_file == null:
		_scoreboard = _default_scores
		return
	
	var score_json = score_file.get_line()
	var raw_scores = JSON.parse_string(score_json)
	
	if score_json == null or raw_scores == null:
		_scoreboard = _default_scores
		return
	
	_scoreboard = []
	for raw_entry in raw_scores:
		_scoreboard.append(ScoreEntry.new(raw_entry["name"], raw_entry["score"]))


func write_scores_to_file() -> void:
	var score_file = FileAccess.open("user://scoreboard.json", FileAccess.WRITE)
	var score_json = JSON.stringify(_scoreboard.map(func(entry): return entry.save()))
	score_file.store_line(score_json)
