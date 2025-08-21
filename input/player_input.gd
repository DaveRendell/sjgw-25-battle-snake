class_name PlayerInput extends Node

signal up_pressed
signal down_pressed
signal left_pressed
signal right_pressed
signal accept_pressed
signal cancel_pressed
signal menu_pressed

var player_prefix = "p1":
	set(value):
		player_prefix = value
		_set_input_groups()

var _input_group_up: StringName
var _input_group_down: StringName
var _input_group_left: StringName
var _input_group_right: StringName
var _input_group_accept: StringName
var _input_group_cancel: StringName
var _input_group_menu: StringName

var _up_press_in_cooldown: bool
var _down_press_in_cooldown: bool
var _left_press_in_cooldown: bool
var _right_press_in_cooldown: bool

func _set_input_groups() -> void:
	_input_group_up = StringName(player_prefix + "_up")
	_input_group_down = StringName(player_prefix + "_down")
	_input_group_left = StringName(player_prefix + "_left")
	_input_group_right = StringName(player_prefix + "_right")
	_input_group_accept = StringName(player_prefix + "_accept")
	_input_group_cancel = StringName(player_prefix + "_cancel")
	_input_group_menu = StringName(player_prefix + "_menu")

func _ready() -> void:
	_set_input_groups()

# Returns float between -1.0 and 1.0 representing horizontal player joystick position 
func get_x_axis() -> float:
	return Input.get_axis(_input_group_left, _input_group_right)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(_input_group_up) and not _up_press_in_cooldown:
		up_pressed.emit()
		_up_press_in_cooldown = true
		await get_tree().create_timer(0.1).timeout
		_up_press_in_cooldown = false
		
	if event.is_action_pressed(_input_group_down) and not _down_press_in_cooldown:
		down_pressed.emit()
		_down_press_in_cooldown = true
		await get_tree().create_timer(0.1).timeout
		_down_press_in_cooldown = false
	
	if event.is_action_pressed(_input_group_left) and not _left_press_in_cooldown:
		left_pressed.emit()
		_left_press_in_cooldown = true
		await get_tree().create_timer(0.1).timeout
		_left_press_in_cooldown = false
	
	if event.is_action_pressed(_input_group_right) and not _right_press_in_cooldown:
		right_pressed.emit()
		_right_press_in_cooldown = true
		await get_tree().create_timer(0.1).timeout
		_right_press_in_cooldown = false
		
	if event.is_action_pressed(_input_group_accept): accept_pressed.emit()
	if event.is_action_pressed(_input_group_cancel): cancel_pressed.emit()
	if event.is_action_pressed(_input_group_menu): menu_pressed.emit()
