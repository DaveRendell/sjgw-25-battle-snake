class_name SpawnProfile extends Resource

@export var spawn_enemies: bool = true

@export var spawn_timeout: float = 4.0

@export var wide_probability: float = 0.0
@export var trailer_probability: float = 0.0
@export var swarm_probability: float = 0.0
@export var wall_probability: float = 0.0
@export var surrounder_probability: float = 0.0
@export var better_probability: float = 0.0

@export var cannon: bool = true
@export var booster: bool = true
@export var magnet: bool = true
@export var flamethrower: bool = true
@export var teslacoil: bool = true

func with_spawn_timeout(_spawn_timeout: float) -> SpawnProfile:
	spawn_timeout = _spawn_timeout
	return self

func with_wide_probability(_wide_probability: float) -> SpawnProfile:
	wide_probability = _wide_probability
	return self

func with_trailer_probability(_trailer_probability: float) -> SpawnProfile:
	trailer_probability = _trailer_probability
	return self

func with_swarm_probability(_swarm_probability: float) -> SpawnProfile:
	swarm_probability = _swarm_probability
	return self

func with_wall_probability(_wall_probability: float) -> SpawnProfile:
	wall_probability = _wall_probability
	return self

func with_surrounder_probability(_surrounder_probability: float) -> SpawnProfile:
	surrounder_probability = _surrounder_probability
	return self
