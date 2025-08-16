@tool
class_name Circle extends Node2D

@export var filled: bool = false:
	set(value):
		filled = value
		queue_redraw()

@export var radius: float = 16:
	set(value):
		radius = value
		queue_redraw()
@export var color: Color = Color.FIREBRICK:
	set(value):
		color = value
		queue_redraw()
	

func _draw():
	draw_circle(Vector2.ZERO, radius, color, false, 1.0, false)
