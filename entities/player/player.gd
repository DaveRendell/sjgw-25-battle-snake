class_name Player extends Node2D

var following_segments: Array[Node2D] = []
@onready var _trail: Trail = $Trail

@export var separation: float = 35.0

func _ready() -> void:
	for i in 5:
		add_segment_to_tail.call_deferred()

func add_segment_to_tail() -> void:
	var trail_to_follow: Trail = _trail if following_segments.is_empty() else following_segments[following_segments.size() - 1].get_node("Trail") 
	var segment = Node2D.new()
	var circle = Circle.new()
	circle.name = "Circle"
	circle.color = Color.DARK_GREEN
	var trail_follower = TrailFollower.new()
	trail_follower.name = "TrailFollower"
	trail_follower.distance = separation
	var trail = Trail.new()
	trail.name = "Trail"
	trail_follower.trail = trail_to_follow
	segment.add_child(circle)
	segment.add_child(trail_follower)
	segment.add_child(trail)
	segment.position = trail_to_follow.get_point_distance_from_trail(separation)
	
	trail_to_follow.get_parent().add_sibling(segment, true)
	following_segments.append(segment)
