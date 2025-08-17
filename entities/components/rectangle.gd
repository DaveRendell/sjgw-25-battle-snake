@tool
class_name Rectangle extends Node2D

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
@export var outline_color: Color = Color.FIREBRICK:
	set(value):
		outline_color = value
		queue_redraw()
@export var outline_width: float = 2.0:
	set(value):
		outline_width = value
		queue_redraw()
		
func _draw():
	draw_rect(Rect2(-width / 2, -height / 2, width, height), color, true)
	draw_rect(Rect2(-width / 2, -height / 2, width, height), outline_color, false, outline_width)
