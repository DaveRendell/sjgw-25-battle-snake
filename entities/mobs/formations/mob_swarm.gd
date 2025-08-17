extends Node2D

@export var mob_scene: PackedScene = preload("res://entities/mobs/mob.tscn")
@export var spread: float = 48
@export var count: int = 5

func _ready() -> void:
	for i in count:
		var spoke_vector = spread * Vector2.from_angle((TAU * i) / count)
		_spawn(mob_scene, spoke_vector)
	queue_free()

func _spawn(mob_scene: PackedScene, relative_position: Vector2) -> void:
	var mob = mob_scene.instantiate()
	mob.position = position + relative_position
	add_sibling.call_deferred(mob)
