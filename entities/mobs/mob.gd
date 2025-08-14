class_name Mob extends Node2D

const PICKUP = preload("res://entities/pickup.tscn")
const EXPLOSION = preload("res://effects/explosion.tscn")

@onready var attract: Attract = $BoidSteering/Attract
@onready var avoid: Avoid = $BoidSteering/Avoid
@onready var align: Align = $BoidSteering/Align

func destroy(drop_pickup: bool = true) -> void:
	if drop_pickup:
		var pickup = PICKUP.instantiate()
		pickup.position = position
		add_sibling.call_deferred(pickup)
		ScoreManager.increase_score(250)
		
	var explosion = EXPLOSION.instantiate()
	explosion.position = position
	add_sibling.call_deferred(explosion)
	SfxManager.play_explosion()
	
	queue_free()
