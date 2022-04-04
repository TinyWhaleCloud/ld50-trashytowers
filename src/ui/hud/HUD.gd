class_name HUD
extends CanvasLayer

# Node references
onready var game_over_screen := $GameOverScreen as Panel
onready var player1_score_label := $Player1ScoreLabel as Label
onready var player2_score_label := $Player2ScoreLabel as Label

var player1_score:int = 0
var player2_score:int = 0

# Game state
var total_player_count := 0


func _ready() -> void:
    # Hide game over screen
    game_over_screen.visible = false
    game_over_screen.set_process_input(false)


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
        if player_number == 1:
            player1_score = score
        else:
            player2_score = score
    else:
        score_label.text = "Score: %d" % [score]

func show_game_over(singleplayer: bool, player_number: int) -> void:
    $GameOverScreen/PlayAgainButton.grab_focus()
    game_over_screen.set_process_input(true)
    if singleplayer:
        $GameOverScreen/TextContainer/WhoWonDisp.visible = false
        $GameOverScreen/TextContainer/Spacer2.visible = false
        $GameOverScreen/TextContainer/ScoreDisp.text = get_player_score_label(1).text
    else:
        var who_won: int
        var score: int
        if player_number == 1:
            who_won = 2
            score = player2_score
        else:
            who_won = 1
            score = player1_score
        $GameOverScreen/TextContainer/WhoWonDisp.text = "Player %d won" % who_won
        $GameOverScreen/TextContainer/ScoreDisp.text = "Score: %s" % score
    game_over_screen.visible = true

func _on_PlayAgainButton_pressed() -> void:
    get_tree().reload_current_scene()

func _on_BackToMenuButton_pressed() -> void:
    get_tree().change_scene_to(load("res://screens/title_screen/TitleScreen.tscn"))
