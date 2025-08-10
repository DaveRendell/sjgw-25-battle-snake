class_name BoidSteering extends Node

var behaviours: Array[BoidBehaviour]
@onready var _parent: Node2D = get_parent()
@export var vehicle_movement: VehicleMovement

func _ready() -> void:
	for child in get_children():
		var behaviour: BoidBehaviour = child
		behaviours.append(behaviour)

func _physics_process(_delta: float) -> void:
	var ideal_vector = Vector2.ZERO
	for behaviour in behaviours:
		ideal_vector += behaviour.get_vector(_parent.position)
	if ideal_vector.length() == 0: return
	ideal_vector = ideal_vector.normalized()
	
	vehicle_movement.heading = ideal_vector
