extends Node2D

const MainGame = preload("res://screens/main_game/MainGame.tscn")
const InfoScreen = preload("res://screens/info_screen/InfoScreen.tscn")

var loading_game := false


func _ready() -> void:
    $Header.grab_focus()
    $SoundEffectsChecked.pressed = Settings.sfx_enabled
    $MusicEnabled.pressed = Settings.music_enabled
    if Settings.music_enabled:
        $TitleMusicPlayer.play()


func _input(event: InputEvent) -> void:
    # Exit the game with Escape
    if event.is_action_pressed("ui_cancel"):
        get_tree().quit()


# Start the game in the specified game mode
func start_game() -> void:
    if loading_game:
        return

    print("Start game: Switch to MainGame scene")
    loading_game = true

    if Settings.sfx_enabled:
        $StartGameSoundPlayer.play()
        yield($StartGameSoundPlayer, "finished")

    # Set game mode and change scene to main game
    get_tree().change_scene_to(MainGame)


# Sets the game mode
func set_game_mode(game_mode: int) -> void:
    Settings.game_mode = game_mode


# Show the info screen before starting the game
func show_info_screen() -> void:
    $InfoScreen.show()


# Start buttons
func _on_SinglePlayerButton_pressed() -> void:
    set_game_mode(Settings.GameMode.MODE_SOLO)
    show_info_screen()

func _on_ChaosButton_pressed() -> void:
    set_game_mode(Settings.GameMode.MODE_MULTI_CHAOS)
    show_info_screen()

func _on_HotseatButton_pressed() -> void:
    set_game_mode(Settings.GameMode.MODE_MULTI_HOTSEAT)
    show_info_screen()

# Called when the info screen is visible and any key is pressed
func _on_InfoScreen_start_game() -> void:
    start_game()


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
