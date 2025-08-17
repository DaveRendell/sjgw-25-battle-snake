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

func _draw() -> void:
	if following_segments.is_empty(): return
	
	var colour = Color.WHITE_SMOKE
	var outline_colour = Color.WEB_PURPLE
	var outline_width: float = 2.0
	var body_width = 36.0
	var head_width = 24.0
	
	var nose_left = Vector2(-head_width / sqrt(2), - head_width / sqrt(2))
	var nose_tip = Vector2(0, -sqrt(2) * head_width)
	var nose_right = Vector2(head_width / sqrt(2), - head_width / sqrt(2))
	draw_colored_polygon([nose_left, nose_tip, nose_right], colour)
	draw_circle(Vector2.ZERO, head_width, colour)
	draw_line(nose_left, nose_tip, outline_colour, outline_width)
	draw_line(nose_right, nose_tip, outline_colour, outline_width)
	draw_arc(Vector2.ZERO, head_width, - TAU / 8, TAU / 8, 8, outline_colour, outline_width)
	draw_arc(Vector2.ZERO, head_width, 3 * TAU / 8, 5 * TAU / 8, 8, outline_colour, outline_width)
	
	var last_left = Vector2(-head_width / sqrt(2), head_width / sqrt(2))
	var last_right = Vector2(head_width / sqrt(2), head_width / sqrt(2))
	
	for segment in following_segments:
		var relative_position = segment.position - position
		var new_left = (relative_position + Vector2(0, -body_width / 2).rotated(segment.rotation)).rotated(-rotation)
		var new_right = (relative_position + Vector2(0, body_width / 2).rotated(segment.rotation)).rotated(-rotation)
		draw_colored_polygon([last_left, last_right, new_right], colour)
		draw_colored_polygon([last_left, new_right, new_left], colour)
		draw_line(last_left, new_left, outline_colour, outline_width)
		draw_line(last_right, new_right, outline_colour, outline_width)
		last_left = new_left
		last_right = new_right
	
	var tail_segment = following_segments.back()
	var tail_relative_position = tail_segment.position - position
	var tail_point = (tail_relative_position + Vector2(-2 * body_width, 0).rotated(tail_segment.rotation)).rotated(-rotation)
	draw_colored_polygon([last_left, tail_point, last_right], colour)
	draw_line(last_left, tail_point, outline_colour, outline_width)
	draw_line(last_right, tail_point, outline_colour, outline_width)


func _physics_process(_delta: float) -> void:
	queue_redraw()

func _on_timer_timeout() -> void:
	maintain_distance.target_distance -= 1
	print(maintain_distance.target_distance)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	var health_bar = HEALTH_BAR.instantiate()
	health_bar.boss = self
	get_tree().get_first_node_in_group("hud").add_sibling(health_bar)
