class_name Player extends Node2D

signal health_changed(health: int)
signal xp_changed(to_level_up: int)
signal destroyed

const SEGMENT_SELECT = preload("res://ui/segment_select.tscn")
const SEGMENT = preload("res://entities/player/segments/normal_segment/segment.tscn")
const CANNON_SEGMENT = preload("res://entities/player/segments/cannon_segment/cannon_segment.tscn")
const MAGNET_SEGMENT = preload("res://entities/player/segments/magnet_segment/magnet_segment.tscn")
const BOOSTER_SEGMENT = preload("res://entities/player/segments/booster_segment/booster_segment.tscn")
const FLAMETHROWER_SEGMENT = preload("res://entities/player/segments/flamethrower_segment/flamethrower_segment.tscn")
const TESLA_COIL_SEGMENT = preload("res://entities/player/segments/tesla_coil_segment/tesla_coil_segment.tscn")

var segments_by_name = {
	"CANNON": CANNON_SEGMENT,
	"BOOSTER": BOOSTER_SEGMENT,
	"MAGNET": MAGNET_SEGMENT,
	"FLAMETHROWER": FLAMETHROWER_SEGMENT,
	"TESLACOIL": TESLA_COIL_SEGMENT,
}

@onready var player_input: PlayerInput = %PlayerInput
@onready var remote_transform_2d: RemoteTransform2D = %RemoteTransform2D

var following_segments: Array[Node2D] = []
var health: int = 5
var xp: int = 0

@onready var _trail: Trail = $Trail
@onready var collider: StaticBody2D = $Collider

@export var separation: float = 20.0

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
	var spawn_profile = SpawnManager.get_spawn_profile()
	var possible_segments: Array[String] = []
	if spawn_profile.cannon: possible_segments.append("CANNON")
	if spawn_profile.booster: possible_segments.append("BOOSTER")
	if spawn_profile.flamethrower: possible_segments.append("FLAMETHROWER")
	if spawn_profile.magnet: possible_segments.append("MAGNET")
	if spawn_profile.teslacoil: possible_segments.append("TESLACOIL")
	
	var first_offer: String = possible_segments.pick_random()
	var second_offer: String = first_offer
	while second_offer == first_offer: second_offer = possible_segments.pick_random()
	
	var segment_select = SEGMENT_SELECT.instantiate()
	segment_select.options_list.assign([first_offer, second_offer])
	segment_select.player_prefix = player_input.player_prefix
	
	get_tree().paused = true
	get_tree().root.add_child(segment_select)
	
	var selected_index = await segment_select.option_selected
	get_tree().paused = false
	segment_select.queue_free()
	
	return segments_by_name[[first_offer, second_offer][selected_index]]

func _on_mouth_area_entered(area: Area2D) -> void:
	consume_pickup(area)

func consume_pickup(area: Area2D) -> void:
	area.get_parent().queue_free()
	xp += 1
	ScoreManager.increase_score(750)
	
	var needed_for_level_up = 3
	
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

func _draw() -> void:
	if following_segments.is_empty(): return
	
	var colour = Color.WEB_GREEN
	var outline_colour = Color.DARK_RED
	var outline_width: float = 2.0
	var body_width = 16.0
	var head_width = 12.0
	
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
		draw_colored_polygon([last_left, last_right, new_right, new_left], colour)
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

func boost_speed() -> void:
	var vehicle_movement: VehicleMovement = $VehicleMovement
	vehicle_movement.speed += 8
