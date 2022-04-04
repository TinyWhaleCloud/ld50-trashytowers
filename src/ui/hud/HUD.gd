class_name HUD
extends CanvasLayer

# Node references
onready var game_over_screen := $GameOverScreen as Panel
onready var player1_score_label := $Player1ScoreLabel as Label
onready var player2_score_label := $Player2ScoreLabel as Label

# Game state
var total_player_count := 0


func _ready() -> void:
    # Hide game over screen
    game_over_screen.visible = false


func init_hud(_total_player_count: int) -> void:
    total_player_count = _total_player_count
    for i in range(1, total_player_count + 1):
        set_player_score(0, i)

    # Only show score label for player 2 if there is a player 2
    player2_score_label.visible = total_player_count > 1


func get_player_score_label(player_number: int) -> Label:
    # TODO: Dynamic generation of labels using an array
    if player_number == 1:
        return player1_score_label
    elif player_number == 2:
        return player2_score_label
    return null


func set_player_score(score: int, player_number: int) -> void:
    var score_label = get_player_score_label(player_number)
    if not score_label:
        return

    if total_player_count > 1:
        score_label.text = "Player %d - Score: %d" % [player_number, score]
    else:
        score_label.text = "Score: %d" % [score]


func show_game_over() -> void:
    game_over_screen.visible = true
