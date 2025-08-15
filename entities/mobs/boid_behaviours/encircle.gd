class_name Encircle extends BoidBehaviour

@export var weight: float = 1.0

func get_vector(location: Vector2) -> Vector2:
	if PlayerManager.players.is_empty(): return Vector2.ZERO
	
	var closest_position: Vector2 = Vector2.ZERO
	var closest_distance: float = 9999999.9
	
	for target in PlayerManager.players:
		var distance = location.distance_to(target.position)
		if distance < closest_distance:
			closest_position = target.position
			closest_distance = distance
	return weight * location.direction_to(closest_position).rotated(TAU / 4)
