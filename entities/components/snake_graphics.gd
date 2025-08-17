class_name SnakeGraphics extends Node2D

@export var colour = Color.WEB_GREEN
@export var outline_colour = Color.DARK_RED
@export var outline_width: float = 2.0
@export var body_width = 16.0
@export var head_width = 12.0

@onready var parent: Node2D = get_parent()

func _draw() -> void:
	if parent.following_segments.is_empty(): return
	
	var nose_left = Vector2(-head_width / sqrt(2), - head_width / sqrt(2))
	var nose_tip = Vector2(0, -sqrt(2) * head_width)
	var nose_right = Vector2(head_width / sqrt(2), - head_width / sqrt(2))
	draw_colored_polygon([nose_left, nose_tip, nose_right], colour)
	draw_circle(Vector2.ZERO, head_width, colour)
	draw_line(nose_left, nose_tip, outline_colour, outline_width)
	draw_line(nose_right, nose_tip, outline_colour, outline_width)
	draw_arc(Vector2.ZERO, head_width, - TAU / 8, TAU / 8, 8, outline_colour, outline_width)
	draw_arc(Vector2.ZERO, head_width, 3 * TAU / 8, 5 * TAU / 8, 8, outline_colour, outline_width)
	
	var last_left = Vector2(-head_width / sqrt(2), head_width / sqrt(2))
	var last_right = Vector2(head_width / sqrt(2), head_width / sqrt(2))
	
	for segment in parent.following_segments:
		var relative_position = segment.position - parent.position
		var new_left = (relative_position + Vector2(0, -body_width / 2).rotated(segment.rotation)).rotated(-parent.rotation)
		var new_right = (relative_position + Vector2(0, body_width / 2).rotated(segment.rotation)).rotated(-parent.rotation)
		draw_colored_polygon([last_left, last_right, new_right], colour)
		draw_colored_polygon([last_left, new_right, new_left], colour)
		draw_line(last_left, new_left, outline_colour, outline_width)
		draw_line(last_right, new_right, outline_colour, outline_width)
		last_left = new_left
		last_right = new_right
	
	var tail_segment = parent.following_segments.back()
	var tail_relative_position = tail_segment.position - parent.position
	var tail_point = (tail_relative_position + Vector2(-2 * body_width, 0).rotated(tail_segment.rotation)).rotated(-parent.rotation)
	draw_colored_polygon([last_left, tail_point, last_right], colour)
	draw_line(last_left, tail_point, outline_colour, outline_width)
	draw_line(last_right, tail_point, outline_colour, outline_width)

func _physics_process(_delta: float) -> void:
	queue_redraw()
