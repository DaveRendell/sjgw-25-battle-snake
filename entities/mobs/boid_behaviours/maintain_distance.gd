class_name MaintainDistance extends BoidBehaviour

@export var weight: float = 5.0
@export var target_distance: float = 150.0

func get_vector(location: Vector2) -> Vector2:
	if PlayerManager.players.is_empty(): return Vector2.ZERO
	
	var closest_position: Vector2 = Vector2.ZERO
	var closest_distance: float = 9999999.9
	
	for target in PlayerManager.players:
		var distance = location.distance_to(target.position)
		if distance < closest_distance:
			closest_position = target.position
			closest_distance = distance
	
	var factor = (closest_distance - target_distance) * (closest_distance - target_distance) / 25000
	if closest_distance > target_distance:
		return weight * factor * location.direction_to(closest_position)
	elif closest_distance < target_distance:
		return weight * factor * closest_position.direction_to(location)
	else: return Vector2.ZERO
		
