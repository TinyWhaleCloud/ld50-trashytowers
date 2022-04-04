class_name HUD
extends CanvasLayer

# Node references
onready var game_over_screen := $GameOverScreen as Panel
onready var player1_score_box := $Player1ScoreBox as VBoxContainer
onready var player2_score_box := $Player2ScoreBox as VBoxContainer

# Game state
var total_player_count := 0
var player1_score: int = 0
var player2_score: int = 0
var end_score: int = 0


func _ready() -> void:
    # Hide game over screen
    game_over_screen.visible = false
    $HighScoresContainer.visible = false
    game_over_screen.set_process_input(false)


func init_hud(_total_player_count: int) -> void:
    total_player_count = _total_player_count

    for i in range(1, total_player_count + 1):
        set_player_score(0, i)

    if total_player_count == 1:
        player1_score_box.get_node("PlayerLabel").visible = false
        player2_score_box.visible = false


func get_player_score_label(player_number: int) -> Label:
    if player_number == 1:
        return player1_score_box.get_node("ScoreLabel") as Label
    elif player_number == 2:
        return player2_score_box.get_node("ScoreLabel") as Label
    return null


func set_player_score(score: int, player_number: int) -> void:
    var score_label = get_player_score_label(player_number)
    if not score_label:
        return

    # Change text
    score_label.text = "Score: %d" % [score]

    if total_player_count > 1:
        if player_number == 1:
            player1_score = score
        else:
            player2_score = score
    else:
        end_score = score

func draw_high_scores():
    $HighScoresContainer/ScoresContainer.clear()
    for score in HighScores.scores:
        if score.score != 0:
            $HighScoresContainer/ScoresContainer.add_item("%s: %d" % [score.name, score.score])
    $HighScoresContainer.visible = true

func show_game_over(singleplayer: bool, player_number: int) -> void:
    $GameOverScreen/PlayAgainButton.grab_focus()
    game_over_screen.set_process_input(true)
    if singleplayer:
        $GameOverScreen/TextContainer/WhoWonDisp.visible = false
        $GameOverScreen/TextContainer/Spacer2.visible = false
        $GameOverScreen/TextContainer/ScoreDisp.text = get_player_score_label(1).text
        draw_high_scores()
    else:
        var who_won: int
        var score: int
        if player_number == 1:
            who_won = 2
            score = player2_score
        else:
            who_won = 1
            score = player1_score
        end_score = score
        $GameOverScreen/TextContainer/WhoWonDisp.text = "Player %d won" % who_won
        $GameOverScreen/TextContainer/ScoreDisp.text = "Score: %s" % score
    game_over_screen.visible = true

func _on_PlayAgainButton_pressed() -> void:
    get_tree().reload_current_scene()

func _on_BackToMenuButton_pressed() -> void:
    get_tree().change_scene_to(load("res://screens/title_screen/TitleScreen.tscn"))

func _on_SaveScoreButton_pressed():
    HighScores.add_score({"name": $HighScoresContainer/UsernameInput.text, "score": end_score})
    draw_high_scores()
    $HighScoresContainer/SaveScoreButton.visible = false
    $HighScoresContainer/UsernameInput.visible = false
    $GameOverScreen/PlayAgainButton.grab_focus()


func _on_UsernameInput_focus_entered():
    if $HighScoresContainer/UsernameInput.text == "Username":
        $HighScoresContainer/UsernameInput.text = ""
