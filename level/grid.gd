class_name Grid extends Node2D

@export var separation: int = 32
@export var width: int = 640
@export var height: int = 360
@export var colour: Color = Color.WEB_PURPLE

func _draw() -> void:
	var x = 0
	while x < width:
		draw_line(Vector2(x, 0), Vector2(x, height), colour)
		x += separation
	var y = 0
	while y < height:
		draw_line(Vector2(0, y), Vector2(width, y), colour)
		y += separation
