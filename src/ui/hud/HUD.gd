class_name HUD
extends CanvasLayer

func _ready():
    # Hide game over screen
    $GameOverScreen.visible = false
    set_player_score(0)

func set_player_score(score: int):
    $PlayerScoreLabel.text = "Score: %d" % [score]

func show_game_over():
    $GameOverScreen.visible = true
