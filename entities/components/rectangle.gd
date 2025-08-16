@tool
class_name Rectangle extends Node2D

@export var filled: bool = false:
	set(value):
		filled = value
		queue_redraw()

@export var width: float = 16:
	set(value):
		width = value
		queue_redraw()
@export var height: float = 16:
	set(value):
		height = value
		queue_redraw()
@export var color: Color = Color.FIREBRICK:
	set(value):
		color = value
		queue_redraw()

func _draw():
	draw_rect(Rect2(-width / 2, -height / 2, width, height), color, filled, 1.0)
