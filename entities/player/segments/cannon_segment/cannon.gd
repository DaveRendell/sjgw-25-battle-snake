class_name Cannon extends Node2D
const SHELL = preload("res://entities/player/segments/cannon_segment/shell.tscn")

@export var timeout := 1.0
@export var target_range: Area2D
@export var launch_speed = 300.0

@onready var _parent: Node2D = get_parent()

func _ready() -> void:
	get_tree().create_timer(timeout).timeout.connect(_on_timeout)

func _on_timeout() -> void:
	_shoot()
	get_tree().create_timer(timeout).timeout.connect(_on_timeout)

func _shoot() -> void:
	var mobs_in_range = target_range.get_overlapping_bodies()
	if mobs_in_range.is_empty(): return
	mobs_in_range.sort_custom(func(a: Node2D, b: Node2D):
		return _parent.position.distance_to(a.position) < _parent.position.distance_to(b.position))
	var closest_mob: Mob = mobs_in_range.front().get_parent()
	var launch_vector = launch_speed * (closest_mob.position - _parent.position).normalized()
	var shell = SHELL.instantiate()
	shell.velocity = launch_vector
	shell.position = _parent.position
	_parent.add_sibling(shell)
