class_name Pickup extends Node2D

# TODO: Can't type without circular dependency between Mob / Player / Pickup?
func pickup(player) -> void:
	player.gain_xp()
