class_name Jormungandr extends Mob
const JORMUNGANDR_SEGMENT = preload("res://entities/mobs/jormungandr/jormungandr_segment.tscn")
const HEALTH_BAR = preload("res://entities/mobs/jormungandr/health_bar.tscn")

@onready var _trail: Trail = $Trail
@onready var maintain_distance: MaintainDistance = $BoidSteering/MaintainDistance

var following_segments: Array[Mob] = []
@export var length: int = 35

func _ready() -> void:
	for i in length:
		add_segment_to_tail.call_deferred()

func add_segment_to_tail() -> void:
	var trail_to_follow: Trail = _trail if following_segments.is_empty() else following_segments[following_segments.size() - 1].get_node("Trail")
	var segment = JORMUNGANDR_SEGMENT.instantiate()
	segment.head = self
	var trail_follower = segment.get_node("TrailFollower")
	trail_follower.trail = trail_to_follow
	trail_follower.distance = 64
	segment.position = trail_to_follow.get_point_distance_from_trail(trail_follower.distance)
	trail_to_follow.get_parent().add_sibling(segment, true)
	following_segments.append(segment)

func destroy(drop_pickup: bool = true) -> void:
	super(drop_pickup)
	for segment in following_segments:
		segment.destroy()

func _on_timer_timeout() -> void:
	maintain_distance.target_distance -= 1
	print(maintain_distance.target_distance)

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	var health_bar = HEALTH_BAR.instantiate()
	health_bar.boss = self
	get_tree().get_first_node_in_group("hud").add_sibling(health_bar)
