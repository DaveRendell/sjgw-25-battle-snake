class_name TrailFollower extends Node

@export var trail: Trail
@export var distance: float = 35.0
@onready var _parent: Node2D = get_parent()

func _physics_process(_delta: float) -> void:
	if not trail: return
	_parent.position = trail.get_point_distance_from_trail(distance)
