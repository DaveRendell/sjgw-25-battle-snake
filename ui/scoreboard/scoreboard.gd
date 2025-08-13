class_name Scoreboard extends VBoxContainer

var scores: Array[ScoreEntry] = [
	ScoreEntry.new("ABC", 3000),
	ScoreEntry.new("XYZ", 2500),
	ScoreEntry.new("TIE", 2000),
	ScoreEntry.new("ABC", 3000),
	ScoreEntry.new("XYZ", 2500),
	ScoreEntry.new("TIE", 2000),
	ScoreEntry.new("ABC", 3000),
	ScoreEntry.new("XYZ", 2500),
	ScoreEntry.new("TIE", 2000),
	ScoreEntry.new("TIE", 2000),
]

func _ready() -> void:
	for score_entry: ScoreEntry in scores:
		var score_entry_label = Label.new()
		score_entry_label.text = "%s - %d" % [score_entry.name, score_entry.score]
		add_child(score_entry_label)
