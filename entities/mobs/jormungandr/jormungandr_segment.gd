class_name JormungandrSegment extends Mob
const WYRM_SPAWN = preload("res://entities/mobs/wyrm_spawn/wyrm_spawn.tscn")
@export var head: Mob
@onready var timer: Timer = $Timer
@export var spawn_timeout: float = 5.0

func _ready() -> void:
	timer.wait_time = 5.0 + spawn_timeout * randf()

func deal_damage(amount: int) -> void:
	head.deal_damage(amount)


func _on_timer_timeout() -> void:
	if PlayerManager.players.is_empty(): return
	var closest_player: Player
	for player in PlayerManager.players:
		if closest_player == null or player.position.distance_to(position) < closest_player.position.distance_to(position):
			closest_player = player
	
	if closest_player.position.distance_to(position) < 250:
		var wyrm_spawn = WYRM_SPAWN.instantiate()
		wyrm_spawn.position = position
		add_sibling(wyrm_spawn)
