class_name Player extends Node2D

var following_segments: Array[Node2D] = []
@onready var _trail: Trail = $Trail

func _ready() -> void:
	for i in 5:
		add_segment_to_tail.call_deferred()

func add_segment_to_tail() -> void:
	var trail_to_follow = _trail if following_segments.is_empty() else following_segments[following_segments.size() - 1].get_node("Trail") 
	var segment = Node2D.new()
	var circle = Circle.new()
	circle.name = "Circle"
	var trail_follower = TrailFollower.new()
	trail_follower.name = "TrailFollower"
	var trail = Trail.new()
	trail.name = "Trail"
	trail_follower.trail = trail
	segment.add_child(circle)
	segment.add_child(trail_follower)
	segment.add_child(trail)
	
	add_sibling(segment, true)
	following_segments.append(segment)
