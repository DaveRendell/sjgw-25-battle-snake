class_name SpawnProfile extends Resource

@export var spawn_enemies: bool = true

@export var spawn_timeout: float = 4.0
@export var time: float = 60

@export var cannon: bool = true
@export var booster: bool = true
@export var magnet: bool = true
@export var flamethrower: bool = true
@export var teslacoil: bool = true

@export var spawn_rates: Dictionary[PackedScene, float] = {}
