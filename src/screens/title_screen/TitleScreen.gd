extends Node2D

var main_game_scene = preload("res://screens/main_game/MainGame.tscn")
onready var settings = get_node("/root/Settings")

func _ready():
    $SoundEffectsChecked.pressed = settings.sfx_enabled

func _on_StartButton_pressed():
    start_game()

func start_game():
    print("Start game: Switch to MainGame scene")
    if settings.sfx_enabled:
        $StartGameSoundPlayer.play()
        yield($StartGameSoundPlayer, "finished")
    get_tree().change_scene_to(main_game_scene)


func _on_SoundEffectsChecked_toggled(button_pressed:bool):
	settings.sfx_enabled = button_pressed
