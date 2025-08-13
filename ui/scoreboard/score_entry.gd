class_name ScoreEntry

func _init(_name: String, _score: int) -> void:
	name = _name
	score = _score

func save():
	return {
		"name": name,
		"score": score,
	}

@export var name: String
@export var score: int
