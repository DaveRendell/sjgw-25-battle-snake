class_name Player extends Node2D

const SEGMENT = preload("res://entities/player/segment.tscn")

var following_segments: Array[Node2D] = []
@onready var _trail: Trail = $Trail
@onready var collider: StaticBody2D = $Collider

@export var separation: float = 35.0

func _ready() -> void:
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
