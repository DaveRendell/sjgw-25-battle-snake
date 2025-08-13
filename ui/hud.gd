class_name Hud extends CanvasLayer

@export var player: Player

@onready var score_label: Label = $Control/Margins/Score
@onready var health_label: Label = $Control/Margins/Health
@onready var level_up: Label = $Control/Margins/LevelUp
@onready var game_over_label: Label = $Control/GameOver

func _ready() -> void:
	_on_player_health_changed(player.health)
	player.health_changed.connect(_on_player_health_changed)
	player.xp_changed.connect(_on_player_xp_changed)
	player.destroyed.connect(game_over)
	ScoreManager.score_changed.connect(_set_score)

func _on_player_health_changed(health: int) -> void:
	var health_text = "HEALTH: "
	for i in health:
		health_text += "♥"
	health_label.text = health_text

func _on_player_xp_changed(to_level_up: int) -> void:
	var xp_text = "TO LVL UP: " + str(to_level_up)
	level_up.text = xp_text

func _set_score(score: int) -> void:
	score_label.text = "SCORE: %d" % score

func game_over() -> void:
	game_over_label.show()
	var final_y_position = game_over_label.position.y
	game_over_label.position.y = -30
	await create_tween().tween_property(game_over_label, "position:y", final_y_position, 0.25).finished
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://ui/menu_scenes/score_enter_screen.tscn")
