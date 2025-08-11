class_name Hud extends CanvasLayer

@export var player: Player

@onready var health_label: Label = $Control/Margins/Health
@onready var level_up: Label = $Control/Margins/LevelUp
@onready var game_over_label: Label = $Control/GameOver

func _ready() -> void:
	_on_player_health_changed(player.health)
	player.health_changed.connect(_on_player_health_changed)
	player.xp_changed.connect(_on_player_xp_changed)
	player.destroyed.connect(game_over)

func _on_player_health_changed(health: int) -> void:
	var health_text = "HEALTH: "
	for i in health:
		health_text += "♥"
	health_label.text = health_text

func _on_player_xp_changed(to_level_up: int) -> void:
	var xp_text = "TO LVL UP: " + str(to_level_up)
	level_up.text = xp_text

func game_over() -> void:
	game_over_label.show()
	var final_y_position = game_over_label.position.y
	game_over_label.position.y = -30
	create_tween().tween_property(game_over_label, "position:y", final_y_position, 0.25)
