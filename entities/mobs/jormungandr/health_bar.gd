extends CanvasLayer
@onready var label: RichTextLabel = $Control/Label
@onready var progress_bar: ProgressBar = $Control/ProgressBar

var boss: Mob

func _ready() -> void:
	progress_bar.value = boss.health
	progress_bar.max_value = boss.health
	boss.destroyed.connect(func():
		await get_tree().create_timer(3.0).timeout
		queue_free())
	label.visible_characters = 0
	var og_width = progress_bar.custom_minimum_size.x
	progress_bar.custom_minimum_size.x = 0
	get_tree().create_tween().tween_property(progress_bar, "custom_minimum_size:x", og_width, 4.0)
	
	boss.health_changed.connect(func(hp: int): progress_bar.value = hp)
	
	while label.visible_ratio < 1.0:
		await get_tree().create_timer(0.1).timeout
		label.visible_characters += 1
