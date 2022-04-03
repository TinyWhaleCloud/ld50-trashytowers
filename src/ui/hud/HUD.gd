class_name HUD
extends CanvasLayer

onready var game_over_screen := $GameOverScreen as Panel
onready var player_score_label := $PlayerScoreLabel as Label

func _ready() -> void:
    # Hide game over screen
    game_over_screen.visible = false
    set_player_score(0)

func set_player_score(score: int) -> void:
    player_score_label.text = "Score: %d" % [score]

func show_game_over() -> void:
    game_over_screen.visible = true
