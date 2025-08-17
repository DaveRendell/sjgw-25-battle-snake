class_name MobSpawner extends Node

const MOB = preload("res://entities/mobs/mob.tscn")
const TRAILER_MOB = preload("res://entities/mobs/trailer_mob/trailer_mob.tscn")
const WIDE_MOB = preload("res://entities/mobs/wide_mob/wide_mob.tscn")
const BETTER_MOB = preload("res://entities/mobs/better_mob/better_mob.tscn")

@export var radius: float = 400
@export var timeout: float = 4.0
@export var player: Player

@onready var _parent: Node2D = get_parent()

func _ready() -> void:
	get_tree().create_timer(timeout).timeout.connect(on_timeout)

func on_timeout() -> void:
	_pick_spawn_scenario()
	
	get_tree().create_timer(timeout).timeout.connect(on_timeout)

func _pick_spawn_scenario() -> void:
	var spawn_profile: SpawnProfile = SpawnManager.get_spawn_profile()
	if not spawn_profile.spawn_enemies: return
	
	var angle = randf_range(0, TAU)
	var relative_position = radius * Vector2.from_angle(angle)
	
	var p = randf()
	if p < spawn_profile.wide_probability: return _spawn(WIDE_MOB, relative_position)
	else: p -= spawn_profile.wide_probability
	
	if p < spawn_profile.trailer_probability: return _spawn(TRAILER_MOB, relative_position)
	else: p -= spawn_profile.trailer_probability
	
	if p < spawn_profile.swarm_probability: return _spawn_swarm(MOB, relative_position, 64, 5)
	else: p -= spawn_profile.swarm_probability
	
	if p < spawn_profile.wall_probability:
		var wall_length = 5
		var offset_vector: Vector2 = 80 * relative_position.normalized().rotated(TAU / 4)
		for i in wall_length:
			var j = i - ceil(float(wall_length) / 2)
			_spawn(WIDE_MOB, relative_position + j * offset_vector)
	else: p -= spawn_profile.wall_probability
	
	if p < spawn_profile.surrounder_probability: return _spawn_swarm(MOB, Vector2.ZERO, radius, 50)
	else: p -= spawn_profile.surrounder_probability
	
	if p < spawn_profile.better_probability: return _spawn_swarm(BETTER_MOB, relative_position, 64, 5)
	else: p -= spawn_profile.better_probability
	
	return _spawn(MOB, relative_position)

func _spawn(mob_scene: PackedScene, relative_position: Vector2) -> void:
	var mob = mob_scene.instantiate()
	mob.position = _parent.position + relative_position
	_parent.add_sibling.call_deferred(mob)
	
func _spawn_swarm(mob_scene: PackedScene, relative_position: Vector2, spread: float, number: int) -> void:
	for i in number:
		var spoke_vector = spread * Vector2.from_angle((TAU * i) / number)
		_spawn(mob_scene, relative_position + spoke_vector)
