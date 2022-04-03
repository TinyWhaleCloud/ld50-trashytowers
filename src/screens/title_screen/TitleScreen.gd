extends Node2D

const MainGame = preload("res://screens/main_game/MainGame.tscn")
onready var settings := get_node("/root/Settings") as Settings

func _ready() -> void:
    $SoundEffectsChecked.pressed = settings.sfx_enabled

func _input(event: InputEvent) -> void:
    # Exit the game with Escape
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()

func _on_StartButton_pressed() -> void:
    start_game()

func start_game() -> void:
    print("Start game: Switch to MainGame scene")
    if settings.sfx_enabled:
        $StartGameSoundPlayer.play()
        yield($StartGameSoundPlayer, "finished")
    get_tree().change_scene_to(MainGame)


func _on_SoundEffectsChecked_toggled(button_pressed: bool) -> void:
    settings.sfx_enabled = button_pressed
