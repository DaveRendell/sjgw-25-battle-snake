extends Mob
const TRAILER_SEGMENT = preload("res://entities/mobs/trailer_mob/trailer_segment.tscn")
@onready var _trail: Trail = $Trail

var following_segments: Array[Mob] = []
@export var length: int = 3

func _ready() -> void:
	for i in length:
		add_segment_to_tail.call_deferred()

func add_segment_to_tail() -> void:
	var trail_to_follow: Trail = _trail if following_segments.is_empty() else following_segments[following_segments.size() - 1].get_node("Trail")
	var segment = TRAILER_SEGMENT.instantiate()
	segment.head = self
	var trail_follower = segment.get_node("TrailFollower")
	trail_follower.trail = trail_to_follow
	trail_follower.distance = 30 if following_segments.is_empty() else 20
	segment.position = trail_to_follow.get_point_distance_from_trail(trail_follower.distance)
	
	trail_to_follow.get_parent().add_sibling(segment, true)
	following_segments.append(segment)

func destroy(drop_pickup: bool = true) -> void:
	super(drop_pickup)
	for segment in following_segments:
		segment.destroy()
