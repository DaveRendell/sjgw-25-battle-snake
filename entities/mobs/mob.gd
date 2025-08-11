class_name Mob extends Node2D

const PICKUP = preload("res://entities/pickup.tscn")

@onready var attract: Attract = $BoidSteering/Attract
@onready var avoid: Avoid = $BoidSteering/Avoid
@onready var align: Align = $BoidSteering/Align

@export var player: Player

func _ready() -> void:
	attract.target = player
	avoid.exception = player.collider

func destroy(drop_pickup: bool = true) -> void:
	if drop_pickup:
		var pickup = PICKUP.instantiate()
		pickup.position = position
		add_sibling.call_deferred(pickup)
	queue_free()
