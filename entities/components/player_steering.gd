class_name PlayerSteering extends Node

@export var player_input: PlayerInput
@export var vehicle_movement: VehicleMovement

# I think this is the number of radians the character will rotate in a second at full lock
@export var steer_speed: float = 3.0

func _physics_process(delta: float) -> void:
	var rotation = (steer_speed / 60) * player_input.get_x_axis()
	vehicle_movement.heading = vehicle_movement.heading.rotated(rotation)
