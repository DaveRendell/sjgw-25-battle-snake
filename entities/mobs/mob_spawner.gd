class_name MobSpawner extends Node

const MOB = preload("res://entities/mobs/mob.tscn")

@export var radius: float = 700
@export var timeout: float = 4.0
@export var player: Player

@onready var _parent: Node2D = get_parent()

func _ready() -> void:
	get_tree().create_timer(timeout).timeout.connect(spawn_mob)

func spawn_mob() -> void:
	var angle = randf_range(0, TAU)
	var relative_position = radius * Vector2.from_angle(angle)
	
	var mob = MOB.instantiate()
	
	mob.position = _parent.position + relative_position
	mob.player = player
	_parent.add_sibling.call_deferred(mob)
	
	get_tree().create_timer(timeout).timeout.connect(spawn_mob)
