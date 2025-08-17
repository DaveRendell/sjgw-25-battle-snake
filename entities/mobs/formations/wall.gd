extends Node2D

@export var mob_scene: PackedScene = preload("res://entities/mobs/wide_mob/wide_mob.tscn")
@export var spread: float = 48
@export var count: int = 5

func _ready() -> void:
	var relative_position = position - PlayerManager.players.front().position
	var offset_vector: Vector2 = 80 * relative_position.normalized().rotated(TAU / 4)
	for i in count:
		var j = i - ceil(float(count) / 2)
		_spawn(mob_scene, relative_position + j * offset_vector)
	queue_free()

func _spawn(mob_scene: PackedScene, relative_position: Vector2) -> void:
	var mob = mob_scene.instantiate()
	mob.position = position + relative_position
	add_sibling.call_deferred(mob)
