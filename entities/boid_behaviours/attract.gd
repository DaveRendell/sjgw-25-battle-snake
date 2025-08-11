class_name Attract extends BoidBehaviour

@export var weight: float = 1.0
@export var target: Node2D

func get_vector(location: Vector2) -> Vector2:
	if target == null: return Vector2.ZERO
	
	return location.direction_to(target.position)
