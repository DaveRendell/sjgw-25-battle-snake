extends Segment
const LIGHTNING_ATTACK = preload("res://entities/player/segments/tesla_coil_segment/lightning_attack.tscn")

func _on_timer_timeout() -> void:
	var lightning_attack = LIGHTNING_ATTACK.instantiate()
	lightning_attack.position = position
	lightning_attack.start_point = self
	add_sibling(lightning_attack)
