extends CanvasLayer
@onready var label: RichTextLabel = $Background/MarginContainer/RichTextLabel
@onready var timer: Timer = $Timer

signal finished

func _ready() -> void:
	label.visible_characters = 0
	
	while label.visible_ratio < 1.0:
		timer.start(0.1)
		await timer.timeout
		label.visible_characters += 1
		SfxManager.play_blip()
	timer.start(5.0)
	await timer.timeout
	finished.emit()
	queue_free()
