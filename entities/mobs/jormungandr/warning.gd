extends CanvasLayer
@onready var label: RichTextLabel = $Background/MarginContainer/RichTextLabel

signal finished

func _ready() -> void:
	label.visible_characters = 0
	
	while label.visible_ratio < 1.0:
		await get_tree().create_timer(0.1).timeout
		label.visible_characters += 1
	await get_tree().create_timer(5.0).timeout
	finished.emit()
	queue_free()
