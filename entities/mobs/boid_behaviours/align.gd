class_name Align extends BoidBehaviour

@export var weight: float = 1.0
@export var behaviour_range: Area2D
@export var own_collider: CollisionObject2D

func get_vector(location: Vector2) -> Vector2:
	var other_entities: Array[Node2D] = behaviour_range.get_overlapping_bodies()
	
	var ret: Vector2 = Vector2.ZERO
	
	for entity: Node2D in other_entities:
		if entity == own_collider: continue
		
		var magnitude = 1 / entity.global_position.distance_squared_to(location)
		if entity.get_parent().has_node("VehicleMovement"):
			var other_movement: VehicleMovement = entity.get_parent().get_node("VehicleMovement")
			ret += magnitude * other_movement.heading.normalized()
	
	return weight * ret.normalized()
