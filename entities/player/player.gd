class_name Player extends Node2D

signal health_changed(health: int)
signal xp_changed(to_level_up: int)
signal destroyed

const SEGMENT_SELECT = preload("res://ui/segment_select.tscn")
const SEGMENT = preload("res://entities/player/segments/normal_segment/segment.tscn")
const CANNON_SEGMENT = preload("res://entities/player/segments/cannon_segment/cannon_segment.tscn")
const MAGNET_SEGMENT = preload("res://entities/player/segments/magnet_segment/magnet_segment.tscn")

@onready var player_input: PlayerInput = %PlayerInput
@onready var remote_transform_2d: RemoteTransform2D = %RemoteTransform2D

var following_segments: Array[Node2D] = []
var health: int = 5
var xp: int = 0

@onready var _trail: Trail = $Trail
@onready var collider: StaticBody2D = $Collider

@export var separation: float = 35.0

@export var player_prefix: String = "p1"

func _ready() -> void:
	ScoreManager.reset_score()
	player_input.player_prefix = player_prefix
	for i in 4:
		add_segment_to_tail.call_deferred()

func add_segment_to_tail(allow_choose: bool = false) -> void:
	var segment_scene: PackedScene = await choose_segment() if allow_choose && ((following_segments.size() - 2) % 3 == 0) else SEGMENT
	add_segment(segment_scene)

func add_segment(segment_scene: PackedScene) -> void:
	var segment: Segment = segment_scene.instantiate()
	
	var trail_to_follow: Trail = _trail if following_segments.is_empty() else following_segments[following_segments.size() - 1].get_node("Trail")
	segment.player = self
	var trail_follower = segment.get_node("TrailFollower")
	trail_follower.trail = trail_to_follow
	trail_follower.distance = separation
	segment.position = trail_to_follow.get_point_distance_from_trail(separation)
	
	trail_to_follow.get_parent().add_sibling(segment, true)
	following_segments.append(segment)

func choose_segment() -> PackedScene:
	var segment_select = SEGMENT_SELECT.instantiate()
	segment_select.options_list.assign(["CANNON", "MAGNET", "PLAIN JANE"])
	segment_select.player_prefix = player_input.player_prefix
	
	get_tree().paused = true
	get_tree().root.add_child(segment_select)
	
	var selected_index = await segment_select.option_selected
	get_tree().paused = false
	segment_select.queue_free()
	
	return [CANNON_SEGMENT, MAGNET_SEGMENT, SEGMENT][selected_index]

func _on_mouth_area_entered(area: Area2D) -> void:
	consume_pickup(area)

func consume_pickup(area: Area2D) -> void:
	area.get_parent().queue_free()
	xp += 1
	ScoreManager.increase_score(750)
	
	var needed_for_level_up = 10
	
	if xp == needed_for_level_up:
		xp -= needed_for_level_up
		add_segment_to_tail.call_deferred(true)
		SfxManager.play_level_up()
	else:
		SfxManager.play_pickup()
	
	xp_changed.emit(needed_for_level_up - xp)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.get_parent() is Mob:
		var mob: Mob = body.get_parent()
		_on_mob_collision(mob)
	
	if body.get_parent() is Segment:
		_on_segment_collision()

func _on_mob_collision(mob: Mob) -> void:
	mob.destroy(false)
	
	health -= 1
	health_changed.emit(health)
	
	if health == 0:
		_game_over()

func _on_segment_collision() -> void:
	_game_over()

func _game_over() -> void:
	PlayerManager.players.erase(self)
	queue_free()
	for segment in following_segments:
		segment.queue_free()
	destroyed.emit()
