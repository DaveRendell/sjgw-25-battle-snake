class_name SegmentSelect extends CanvasLayer

signal option_selected(index: int)

@onready var options: VBoxContainer = %Options
@onready var selector: Label = $Background/Selector
@onready var player_input: PlayerInput = $PlayerInput
@export var options_list: Array[String] = ["CANNON", "MAGNET", "??????"]
@export var player_prefix: String = "p1"

var _selected_index: int = 0

func _ready() -> void:
	player_input.up_pressed.connect(_up_pressed)
	player_input.down_pressed.connect(_down_pressed)
	player_input.accept_pressed.connect(_accept_pressed)
	
	for child in options.get_children(): child.queue_free()
	for option in options_list:
		var label = Label.new()
		label.text = option
		options.add_child(label)
	
	selector.reparent(options.get_child(3), false)
	player_input.player_prefix = player_prefix

func _up_pressed() -> void:
	_selected_index = posmod(_selected_index - 1, options_list.size())
	_set_selected()

func _down_pressed() -> void:
	_selected_index = posmod(_selected_index + 1, options_list.size())
	_set_selected()

func _accept_pressed() -> void:
	option_selected.emit(_selected_index)

func _set_selected() -> void:
	selector.reparent(options.get_child(_selected_index), false)
