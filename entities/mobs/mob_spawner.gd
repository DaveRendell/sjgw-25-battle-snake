class_name MobSpawner extends Node

const MOB = preload("res://entities/mobs/mob.tscn")
const TRAILER_MOB = preload("res://entities/mobs/trailer_mob/trailer_mob.tscn")
const WIDE_MOB = preload("res://entities/mobs/wide_mob/wide_mob.tscn")
const BETTER_MOB = preload("res://entities/mobs/better_mob/better_mob.tscn")

@export var radius: float = 400
@export var timeout: float = 4.0
@export var player: Player

@onready var _parent: Node2D = get_parent()

var _spawn_timer: Timer

func _ready() -> void:
	_spawn_timer = Timer.new()
	_spawn_timer.wait_time = timeout
	_spawn_timer.timeout.connect(_pick_spawn_scenario)
	add_child(_spawn_timer)
	_spawn_timer.start()

func _pick_spawn_scenario() -> void:
	var spawn_profile: SpawnProfile = SpawnManager.get_spawn_profile()
	if not spawn_profile.spawn_enemies: return
	_spawn_timer.wait_time = spawn_profile.spawn_timeout
	
	
	var total_weight = spawn_profile.spawn_rates.values().reduce(func(a, b): return a + b, 0)
	var mob_pick = total_weight * randf()
	
	var acc = 0.0
	var mob_scene: PackedScene
	for test_scene in spawn_profile.spawn_rates.keys():
		acc += spawn_profile.spawn_rates[test_scene]
		if acc >= mob_pick:
			mob_scene = test_scene
			break
	
	var attempt_count = 0
	while attempt_count < 15:
		var angle = randf_range(0, TAU)
		var relative_position = radius * Vector2.from_angle(angle)
		if _spawn(mob_scene, relative_position): return
		attempt_count += 1
	print("Unable to find spawn position")

func _spawn(mob_scene: PackedScene, relative_position: Vector2) -> bool:
	var spawn_position = _parent.position + relative_position
	if PlayerManager.players.any(func(other_player: Player) -> bool:
		return other_player != player and player.position.distance_to(spawn_position) < 200.0
	):
		return false
	
	var mob = mob_scene.instantiate()
	mob.position = _parent.position + relative_position
	_parent.add_sibling.call_deferred(mob)
	return true
	
func _spawn_swarm(mob_scene: PackedScene, relative_position: Vector2, spread: float, number: int) -> void:
	for i in number:
		var spoke_vector = spread * Vector2.from_angle((TAU * i) / number)
		_spawn(mob_scene, relative_position + spoke_vector)
