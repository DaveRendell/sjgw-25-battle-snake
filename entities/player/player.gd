class_name Player extends Node2D

signal health_changed(health: int)
signal xp_changed(to_level_up: int)
signal destroyed

const SEGMENT = preload("res://entities/player/segment.tscn")

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
	for i in 5:
		add_segment_to_tail.call_deferred()

func add_segment_to_tail() -> void:
	var trail_to_follow: Trail = _trail if following_segments.is_empty() else following_segments[following_segments.size() - 1].get_node("Trail")
	var segment = SEGMENT.instantiate()
	var trail_follower = segment.get_node("TrailFollower")
	trail_follower.trail = trail_to_follow
	trail_follower.distance = separation
	segment.position = trail_to_follow.get_point_distance_from_trail(separation)
	
	trail_to_follow.get_parent().add_sibling(segment, true)
	following_segments.append(segment)

func _on_mouth_area_entered(area: Area2D) -> void:
	area.get_parent().queue_free()
	xp += 1
	ScoreManager.increase_score(750)
	
	var needed_for_level_up = 5
	
	if xp == needed_for_level_up:
		xp -= needed_for_level_up
		add_segment_to_tail.call_deferred()
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
