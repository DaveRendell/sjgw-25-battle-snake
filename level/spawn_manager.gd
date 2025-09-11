extends Node
const WARNING = preload("res://entities/mobs/jormungandr/warning.tscn")
const JORMUNGANDR = preload("res://entities/mobs/jormungandr/jormungandr.tscn")
var stage_id: int = 0
var stage_timer: Timer
var normal_stage_timeout = 60.0

var _stages = [
	preload("res://level/spawn_profiles/stage0.tres"),
	preload("res://level/spawn_profiles/stage1.tres"),
	preload("res://level/spawn_profiles/stage2.tres"),
	preload("res://level/spawn_profiles/stage3.tres"),
	preload("res://level/spawn_profiles/stage4.tres"),
	preload("res://level/spawn_profiles/stage5.tres"),
	preload("res://level/spawn_profiles/stage6.tres"),
	preload("res://level/spawn_profiles/stage7.tres"),
	preload("res://level/spawn_profiles/stage8.tres"),
	preload("res://level/spawn_profiles/stage9.tres"),
]

func _ready() -> void:
	stage_timer = Timer.new()
	stage_timer.timeout.connect(_on_timeout)
	add_child(stage_timer)

func start_game(start_stage: int = 0) -> void:
	stage_id = start_stage
	stage_timer.start(_stages[stage_id].time)

func start_custom(profile: SpawnProfile) -> void:
	_stages = [profile]
	stage_id = 0

func _on_timeout() -> void:
	stage_id += 1
	print("Setting stage to %d" % stage_id)
	if stage_id % _stages.size() == (_stages.size() - 1):
		stage_timer.stop()
		MusicManager.start_boss_music()
		
		var warning = WARNING.instantiate()
		var hud = get_tree().get_first_node_in_group("hud")
		if hud:
			hud.add_sibling(warning)
			await warning.finished
		
		var jormungandr = JORMUNGANDR.instantiate()
		
		var p1: Player = PlayerManager.players.front()
		var boss_spawn_point: Vector2 = p1.position + 1500 * Vector2.LEFT
		jormungandr.position = boss_spawn_point
		
		p1.get_parent().add_child(jormungandr)
		
		jormungandr.destroyed.connect(func():
			stage_id += 1
			stage_timer.start()
			MusicManager.start_stage_music())
	else:
		stage_timer.wait_time = _stages[stage_id].time

func get_spawn_profile() -> SpawnProfile:
	if stage_id >= _stages.size():
		if stage_id % _stages.size() == (_stages.size() - 1): return _stages.back()
		return _stages[_stages.size() - 2]
	return _stages[stage_id]
