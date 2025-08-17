extends Node2D
const LIGHTNING_BOLT = preload("res://entities/player/segments/tesla_coil_segment/lightning_bolt.tscn")
@onready var chain_range: Area2D = $ChainRange
@export var chains = 3
@export var ticks = 5

var start_point: Node2D
var connected_mobs: Array[Mob] = []
var bolts: Array[Sprite2D] = []

func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	for i in chains:
		var mob: Mob = _get_next_in_chain()
		if mob == null: break
		connected_mobs.append(mob)
		chain_range.global_position = mob.global_position
		var position_in_chain = connected_mobs.size()
		mob.destroyed.connect(func():
			connected_mobs = connected_mobs.slice(0, position_in_chain)
			bolts.slice(position_in_chain).map(func(bolt): bolt.queue_free())
			bolts = bolts.slice(0, position_in_chain)
		)
		await get_tree().physics_frame
	connected_mobs = connected_mobs.filter(func(mob): return mob != null)
	for i in connected_mobs.size():
		var bolt = LIGHTNING_BOLT.instantiate()
		bolt.from = start_point if i == 0 else connected_mobs[i - 1]
		bolt.to = connected_mobs[i]
		add_sibling(bolt)
		bolts.append(bolt)
	
	if connected_mobs.is_empty(): queue_free()

func _get_next_in_chain() -> Mob:
	var mobs_in_range: Array = chain_range.get_overlapping_bodies()\
		.map(func(collider): return collider.get_parent())\
		.filter(func(mob: Mob): return !connected_mobs.has(mob))
	if mobs_in_range.is_empty(): return null
	
	var closest_mob: Mob
	var closest_distance: float = 9999999.9
	
	for target: Mob in mobs_in_range:
		var distance = position.distance_to(target.position)
		if distance < closest_distance:
			closest_mob = target
			closest_distance = distance
	return closest_mob

func _on_tick_timer_timeout() -> void:
	connected_mobs.map(func(mob): if mob: mob.deal_damage.call_deferred(1))
	ticks -= 1
	if ticks <= 0:
		for bolt in bolts:
			if bolt: bolt.queue_free()
		queue_free()
