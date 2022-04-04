extends Node2D

const MainGame = preload("res://screens/main_game/MainGame.tscn")

func _ready() -> void:
    $SoundEffectsChecked.pressed = Settings.sfx_enabled
    $MusicEnabled.pressed = Settings.music_enabled
    if Settings.music_enabled:
        $TitleMusicPlayer.play()

func _input(event: InputEvent) -> void:
    # Exit the game with Escape
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()

# Start the game in the specified game mode
func start_game(game_mode: int) -> void:
    print("Start game: Switch to MainGame scene")

    if Settings.sfx_enabled:
        $StartGameSoundPlayer.play()
        yield($StartGameSoundPlayer, "finished")

    # Set game mode and change scene to main game
    Settings.game_mode = game_mode
    get_tree().change_scene_to(MainGame)

# Start buttons
func _on_SinglePlayerButton_pressed() -> void:
    start_game(Settings.GameMode.MODE_SOLO)

func _on_ChaosButton_pressed() -> void:
    start_game(Settings.GameMode.MODE_MULTI_CHAOS)

func _on_HotseatButton_pressed() -> void:
    start_game(Settings.GameMode.MODE_MULTI_HOTSEAT)

# Sound setting
func _on_SoundEffectsChecked_toggled(button_pressed: bool) -> void:
    Settings.sfx_enabled = button_pressed

# Music setting
func _on_MusicEnabled_toggled(button_pressed:bool):
    Settings.music_enabled = button_pressed
    if button_pressed:
        $TitleMusicPlayer.play()
    else:
        $TitleMusicPlayer.stop()
