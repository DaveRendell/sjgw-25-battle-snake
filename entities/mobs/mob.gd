class_name Mob extends Node2D

signal health_changed(hp: int)
signal destroyed

const PICKUP = preload("res://entities/pickup.tscn")
const EXPLOSION = preload("res://effects/explosion.tscn")

@export var health: int = 1

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
	destroyed.emit()
	queue_free()

func deal_damage(amount: int) -> void:
	health -= amount
	health_changed.emit(health)
	if health <= 0: destroy(true)
	else: SfxManager.play_mob_oof()
