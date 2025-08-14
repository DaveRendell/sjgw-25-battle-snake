class_name Rotator extends Node

@onready var _parent: Node2D = get_parent()

@onready var _last_position: Vector2 = _parent.position

func _physics_process(_delta: float) -> void:
	var new_position = _parent.position
	if new_position == _last_position: return
	_parent.rotation = (new_position - _last_position).angle()
	_last_position = new_position
