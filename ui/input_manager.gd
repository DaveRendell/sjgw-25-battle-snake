extends Node

var p1_input: PlayerInput
var p2_input: PlayerInput

func _ready() -> void:
	p1_input = PlayerInput.new()
	p1_input.player_prefix = "p1"
	add_child(p1_input)
	p2_input = PlayerInput.new()
	p2_input.player_prefix = "p2"
	add_child(p2_input)
