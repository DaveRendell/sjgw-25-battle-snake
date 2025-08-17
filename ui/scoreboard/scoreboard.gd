class_name Scoreboard extends VBoxContainer

var scores: Array[ScoreEntry]:
	set(new_scores):
		scores = new_scores
		_update_scores()

var highlight_index = -1

func _update_scores() -> void:
	get_children().map(func(child): child.queue_free())
	var idx = 0
	for score_entry: ScoreEntry in scores:
		var score_entry_label = RichTextLabel.new()
		score_entry_label.text = "%s - %d" % [score_entry.name, score_entry.score]
		if idx == highlight_index:
			score_entry_label.text = "[wave]%s[/wave]" % [score_entry_label.text]
			score_entry_label.clip_contents = false
			score_entry_label.bbcode_enabled = true
		score_entry_label.fit_content = true
		add_child(score_entry_label)
		idx += 1
