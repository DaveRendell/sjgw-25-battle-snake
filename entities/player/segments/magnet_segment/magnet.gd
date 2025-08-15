class_name Magnet extends Node2D

@onready var _parent: Segment = get_parent()

@export var magnet_range: Area2D
@export var magnet_pickup_range: Area2D
@export var acceleration: float = 90.0

var pickup_velocities: Dictionary[Node2D, Vector2] = {}

func _ready() -> void:
	magnet_range.area_entered.connect(func(pickup_area: Area2D):
		pickup_velocities.set(pickup_area.get_parent(), Vector2.ZERO))
	magnet_range.area_exited.connect(func(pickup_area: Area2D):
		pickup_velocities.erase(pickup_area.get_parent()))
	magnet_pickup_range.area_entered.connect(func(area: Area2D):
		_parent.player.consume_pickup(area))

func _physics_process(delta: float) -> void:
	for pickup: Node2D in pickup_velocities.keys():
		var direction_vector = (_parent.position - pickup.position).normalized()
		pickup_velocities[pickup] *= 0.99
		pickup_velocities[pickup] += delta * acceleration * direction_vector
		pickup.position += delta * pickup_velocities[pickup]
