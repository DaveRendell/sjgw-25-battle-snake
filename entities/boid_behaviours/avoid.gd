class_name Avoid extends BoidBehaviour

@export var weight: float = 1.0
@export var behaviour_range: Area2D
@export var own_collider: CollisionObject2D
@export var exception: Node2D

func get_vector(location: Vector2) -> Vector2:
	var other_entities: Array[Node2D] = behaviour_range.get_overlapping_bodies()
	
	var ret: Vector2 = Vector2.ZERO
	
	for entity: Node2D in other_entities:
		if entity == own_collider: continue
		if PlayerManager.players.any(func(player: Player): return player.collider == entity): continue
		
		var magnitude = 1 / entity.global_position.distance_squared_to(location)
		ret += magnitude * entity.global_position.direction_to(location)
	
	return weight * ret
