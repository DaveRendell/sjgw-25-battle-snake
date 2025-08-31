class_name HudMp extends CanvasLayer

@export var player1: Player
@export var player2: Player

@onready var score_label: Label = %Score
@onready var game_over_label: Label = $Control/GameOver

@onready var health_p_1: RichTextLabel = %HealthP1
@onready var level_up_p_1: Label = %LevelUpP1
@onready var health_p_2: RichTextLabel = %HealthP2
@onready var level_up_p_2: Label = %LevelUpP2

func _ready() -> void:
	connect_player1(player1)
	connect_player2(player2)
	ScoreManager.score_changed.connect(_set_score)

func connect_player1(player: Player) -> void:
	_on_player1_health_changed(player.health)
	player.health_changed.connect(_on_player1_health_changed)
	player.xp_changed.connect(_on_player1_xp_changed)

func connect_player2(player: Player) -> void:
	_on_player2_health_changed(player.health)
	player.health_changed.connect(_on_player2_health_changed)
	player.xp_changed.connect(_on_player2_xp_changed)

func _on_player1_health_changed(health: int) -> void:
	var health_text = "HEALTH: [color=red]"
	for i in health:
		health_text += "♥"
	health_text += "[/color]"
	health_p_1.text = health_text

func _on_player1_xp_changed(to_level_up: int) -> void:
	var xp_text = "TO LVL UP: " + str(to_level_up)
	level_up_p_1.text = xp_text

func _on_player2_health_changed(health: int) -> void:
	var health_text = "HEALTH: [color=red]"
	for i in health:
		health_text += "♥"
	health_text += "[/color]"
	health_p_2.text = health_text

func _on_player2_xp_changed(to_level_up: int) -> void:
	var xp_text = "TO LVL UP: " + str(to_level_up)
	level_up_p_2.text = xp_text

func _set_score(score: int) -> void:
	score_label.text = "SCORE: %d" % score

func game_over() -> void:
	game_over_label.show()
	var final_y_position = game_over_label.position.y
	game_over_label.position.y = -30
	await create_tween().tween_property(game_over_label, "position:y", final_y_position, 0.25).finished
