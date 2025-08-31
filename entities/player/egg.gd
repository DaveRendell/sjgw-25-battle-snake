class_name Egg extends Pickup
const PLAYER = preload("res://entities/player/player.tscn")

var player_id: int
var colour: Color
var outline_colour: Color

func pickup(player) -> void:
	var new_player = PLAYER.instantiate()
	new_player.position = position + Vector2(128, 128)
	new_player.player_id = player_id
	add_sibling.call_deferred(new_player)
