class_name BoidDebug extends Node2D

@export var boid_steering: BoidSteering

func _physics_process(_delta: float) -> void:
	global_rotation = 0
	queue_redraw()

var colour_list: Array[Color] = [Color.AQUA, Color.OLIVE_DRAB, Color.PALE_VIOLET_RED, Color.VIOLET]
func _draw() -> void:
	var colour_id = 0
	for behaviour in boid_steering.debug_vectors.keys():
		draw_line(Vector2.ZERO, 100 * boid_steering.debug_vectors[behaviour], colour_list[colour_id])
		colour_id += 1
		
