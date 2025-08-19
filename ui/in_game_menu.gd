class_name InGameMenu extends CanvasLayer

signal option_selected(index: int)

@onready var title: Label = $Background/MarginContainer/Title
@onready var options: VBoxContainer = %Options
@onready var selector: Label = $Background/Selector
@onready var player_input: PlayerInput = $PlayerInput
@export var options_list: Array[String] = ["CANNON", "MAGNET", "??????"]
@export var player_prefix: String = "p1"
@export var allow_cancel: bool = false

var _selected_index: int = 0
var header_text: String

func _ready() -> void:
	title.text = header_text
	player_input.up_pressed.connect(_up_pressed)
	player_input.down_pressed.connect(_down_pressed)
	player_input.accept_pressed.connect(_accept_pressed)
	if allow_cancel:
		player_input.cancel_pressed.connect(_cancel)
		player_input.menu_pressed.connect(_cancel)
	
	for child in options.get_children(): child.queue_free()
	for option in options_list:
		var label = Label.new()
		label.text = option
		options.add_child(label)
	
	selector.reparent(options.get_child(3), false)
	player_input.player_prefix = player_prefix

func _up_pressed() -> void:
	_selected_index = posmod(_selected_index - 1, options_list.size())
	SfxManager.play_blip()
	_set_selected()

func _down_pressed() -> void:
	_selected_index = posmod(_selected_index + 1, options_list.size())
	SfxManager.play_blip()
	_set_selected()

func _accept_pressed() -> void:
	SfxManager.play_blip()
	option_selected.emit(_selected_index)

func _set_selected() -> void:
	selector.reparent(options.get_child(_selected_index), false)

func _cancel() -> void:
	SfxManager.play_blip()
	option_selected.emit(-1)
