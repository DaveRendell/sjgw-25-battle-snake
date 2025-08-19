class_name Player extends Node2D

signal health_changed(health: int)
signal xp_changed(to_level_up: int)
signal destroyed

const IN_GAME_MENU = preload("res://ui/in_game_menu.tscn")
const SEGMENT = preload("res://entities/player/segments/normal_segment/segment.tscn")
const CANNON_SEGMENT = preload("res://entities/player/segments/cannon_segment/cannon_segment.tscn")
const MAGNET_SEGMENT = preload("res://entities/player/segments/magnet_segment/magnet_segment.tscn")
const BOOSTER_SEGMENT = preload("res://entities/player/segments/booster_segment/booster_segment.tscn")
const FLAMETHROWER_SEGMENT = preload("res://entities/player/segments/flamethrower_segment/flamethrower_segment.tscn")
const TESLA_COIL_SEGMENT = preload("res://entities/player/segments/tesla_coil_segment/tesla_coil_segment.tscn")

const EXPLOSION = preload("res://effects/explosion.tscn")

var segments_by_name = {
	"CANNON": CANNON_SEGMENT,
	"BOOSTER": BOOSTER_SEGMENT,
	"MAGNET": MAGNET_SEGMENT,
	"FLAMETHROWER": FLAMETHROWER_SEGMENT,
	"TESLACOIL": TESLA_COIL_SEGMENT,
}

var player_id: int = 1
var player_input: PlayerInput
@onready var remote_transform_2d: RemoteTransform2D = %RemoteTransform2D

var following_segments: Array[Node2D] = []
var health: int = 5
var xp: int = 0

@onready var _trail: Trail = $Trail
@onready var collider: StaticBody2D = $Collider
@onready var player_steering: PlayerSteering = $PlayerSteering

@export var separation: float = 20.0

func _ready() -> void:
	ScoreManager.reset_score()
	match player_id:
		1: player_input = InputManager.p1_input
		2: player_input = InputManager.p2_input
	player_steering.player_input = player_input
	for i in 3:
		add_segment_to_tail.call_deferred()
	await get_tree().process_frame
	xp_changed.emit(following_segments.size())
	player_input.menu_pressed.connect(_pause)

func add_segment_to_tail(allow_choose: bool = false) -> void:
	var segment_scene: PackedScene = await choose_segment() if allow_choose && ((following_segments.size()) % 3 == 0) else SEGMENT
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
	
	var segment_select = IN_GAME_MENU.instantiate()
	segment_select.options_list.assign([first_offer, second_offer])
	segment_select.player_prefix = player_input.player_prefix
	segment_select.header_text = "CHOOSE A POWER-UP!"
	
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
	
	var needed_for_level_up = following_segments.size()
	
	if xp == needed_for_level_up:
		xp -= needed_for_level_up
		add_segment_to_tail.call_deferred(true)
		SfxManager.play_level_up()
	else:
		SfxManager.play_pickup()
	
	xp_changed.emit(needed_for_level_up - xp)

func _pause() -> void:
	var pause_menu = IN_GAME_MENU.instantiate()
	pause_menu.options_list.assign(["CONTINUE", "ALSO CONTINUE?"])
	pause_menu.player_prefix = player_input.player_prefix
	pause_menu.header_text = "PAUSED"
	pause_menu.allow_cancel = true
	
	get_tree().paused = true
	get_tree().root.add_child(pause_menu)
	
	var selected_index = await pause_menu.option_selected
	match selected_index:
		-1:
			pause_menu.queue_free()
			get_tree().paused = false
		0:
			pause_menu.queue_free()
			get_tree().paused = false
		1:
			pause_menu.queue_free()
			get_tree().paused = false

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.get_parent() is Segment or body.get_parent() is JormungandrSegment:
		_on_segment_collision()
	elif body.get_parent() is Mob:
		var mob: Mob = body.get_parent()
		_on_mob_collision(mob)

func _on_mob_collision(mob: Mob) -> void:
	mob.destroy(false)
	
	health -= 1
	health_changed.emit(health)
	SfxManager.play_player_oof()
	
	if health == 0:
		_game_over()

func _on_segment_collision() -> void:
	_game_over()

func _game_over() -> void:
	PlayerManager.players.erase(self)
	queue_free()
	var explosion = EXPLOSION.instantiate()
	explosion.position = position
	add_sibling(explosion)
	for segment in following_segments:
		segment.queue_free()
		var segment_explosion = EXPLOSION.instantiate()
		segment_explosion.position = segment.position
		add_sibling(segment_explosion)
	destroyed.emit()

func boost_speed() -> void:
	var vehicle_movement: VehicleMovement = $VehicleMovement
	vehicle_movement.speed += 8
