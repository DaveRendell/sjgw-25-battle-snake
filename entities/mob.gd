extends Node2D

@onready var attract: Attract = $BoidSteering/Attract
@onready var avoid: Avoid = $BoidSteering/Avoid
@onready var align: Align = $BoidSteering/Align

@export var player: Player

func _ready() -> void:
	attract.target = player
	avoid.exception = player.collider
