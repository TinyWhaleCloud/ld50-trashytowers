extends Node2D

var main_game_scene = preload("res://screens/main_game/MainGame.tscn")

func _ready():
    # TODO: Remove this line
    start_game()

func _on_StartButton_pressed():
    start_game()

func start_game():
    print("Start game: Switch to MainGame scene")
    get_tree().change_scene_to(main_game_scene)
