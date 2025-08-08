class_name PlayerInput extends Node

signal up_pressed
signal down_pressed
signal accept_pressed

var player_prefix = "ui"

var _input_group_up = StringName(player_prefix + "_up")
var _input_group_down = StringName(player_prefix + "_down")
var _input_group_left = StringName(player_prefix + "_left")
var _input_group_right = StringName(player_prefix + "_right")
var _input_group_accept = StringName(player_prefix + "_accept")

# Returns float between -1.0 and 1.0 representing horizontal player joystick position 
func get_x_axis() -> float:
	return Input.get_axis(_input_group_left, _input_group_right)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(_input_group_up): up_pressed.emit()
	if event.is_action_pressed(_input_group_down): down_pressed.emit()
	if event.is_action_pressed(_input_group_accept): accept_pressed.emit()
	
