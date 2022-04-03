extends Node2D

var main_game_scene = preload("res://screens/main_game/MainGame.tscn")

func _on_StartButton_pressed():
    start_game()

func start_game():
    print("Start game: Switch to MainGame scene")
    $StartGameSoundPlayer.play()
    yield($StartGameSoundPlayer, "finished")
    get_tree().change_scene_to(main_game_scene)
