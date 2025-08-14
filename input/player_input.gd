class_name PlayerInput extends Node

signal up_pressed
signal down_pressed
signal accept_pressed

var player_prefix = "p1":
	set(value):
		player_prefix = value
		_set_input_groups()

var _input_group_up: StringName
var _input_group_down: StringName
var _input_group_left: StringName
var _input_group_right: StringName
var _input_group_accept: StringName

func _set_input_groups() -> void:
	_input_group_up = StringName(player_prefix + "_up")
	_input_group_down = StringName(player_prefix + "_down")
	_input_group_left = StringName(player_prefix + "_left")
	_input_group_right = StringName(player_prefix + "_right")
	_input_group_accept = StringName(player_prefix + "_accept")

func _ready() -> void:
	_set_input_groups()

# Returns float between -1.0 and 1.0 representing horizontal player joystick position 
func get_x_axis() -> float:
	return Input.get_axis(_input_group_left, _input_group_right)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(_input_group_up): up_pressed.emit()
	if event.is_action_pressed(_input_group_down): down_pressed.emit()
	if event.is_action_pressed(_input_group_accept): accept_pressed.emit()
	
