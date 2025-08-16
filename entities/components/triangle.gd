@tool
class_name Triangle extends Node2D

@export var filled: bool = false:
	set(value):
		filled = value
		queue_redraw()

@export var base: float = 16:
	set(value):
		base = value
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
	if filled:
		draw_colored_polygon([
			Vector2(- base / 2, height / 2),
			Vector2(0, - height / 2),
			Vector2(base / 2, height / 2),
		], color)
	else:
		draw_line(Vector2(- base / 2, height / 2), Vector2(0, - height / 2), color)
		draw_line(Vector2(base / 2, height / 2), Vector2(0, - height / 2), color)
		draw_line(Vector2(- base / 2, height / 2), Vector2(base / 2, height / 2), color)
