# Handles making a node move in a vehicle-like fasion, where it has a heading
# and moves forward in that direction, and can steer left and right.

class_name VehicleMovement extends Node

@onready var parent: Node2D = get_parent()

# Vector containing current direction the vehicle is moving. Size of the vector
# does not matter, this vector should be unit length (see `speed`)
@export var heading: Vector2 = Vector2.RIGHT

# The speed the vehicle is currently travelling at, in the direction of `heading`
# The vehicle travels that distance in a second
@export var speed: float = 50.0

@export var turning_speed: float = 2.5

@export var ideal_heading: Vector2 = Vector2.RIGHT 

func _physics_process(delta: float) -> void:
	if heading != ideal_heading:
		var angle = heading.angle_to(ideal_heading)
		var turn_amount = min(abs(angle), delta * turning_speed)
		if angle > 0:
			heading = heading.rotated(turn_amount)
		else:
			heading = heading.rotated(-turn_amount)
	parent.position += delta * speed * heading.normalized()
	parent.rotation = heading.rotated(TAU / 4).angle()
