extends Node2D

signal start_game

func _input(event: InputEvent) -> void:
    if visible:
        # Suppress input handling on the rest of the title screen
        get_tree().set_input_as_handled()

        # On Escape, return to the title screen
        if event.is_action_pressed("ui_cancel"):
            visible = false
            return

        # Start the screen if any key (except for Escape) is pressed
        if (event is InputEventKey or event is InputEventJoypadButton) and not event.is_pressed():
            prints(self, 'Any key was pressed')
            emit_signal("start_game")


func show():
    # Show the screen
    visible = true

    var is_singleplayer: bool = Settings.game_mode == Settings.GameMode.MODE_SOLO
    var joypad_count = Input.get_connected_joypads().size()

    if is_singleplayer or joypad_count > 1:
        $Player1Controls/P1ControlsLabel.text = 'Controls'
        $Player2Controls.visible = false
    else:
        $Player1Controls/P1ControlsLabel.text = 'Player 1'
        $Player2Controls.visible = true

    if joypad_count > 0:
        $Player1Controls/EscKey.texture = load("res://screens/info_screen/blackPixel.png")
        $Player1Controls/BackToMenuSpacer2.texture = load("res://screens/info_screen/controllerButtonSelect.png")
        $Player1Controls/WKey.texture = load("res://screens/info_screen/dpadUp.png")
        $Player1Controls/QKey.texture = load("res://screens/info_screen/controllerButtonDown.png")
        $Player1Controls/EKey.texture = load("res://screens/info_screen/controllerButtonRight.png")
        $Player1Controls/AKey.texture = load("res://screens/info_screen/dpadLeft.png")
        $Player1Controls/DKey.texture = load("res://screens/info_screen/dpadRight.png")
        $Player1Controls/SKey.texture = load("res://screens/info_screen/dpadDown.png")
        $Player1Controls/SpaceBar.texture = load("res://screens/info_screen/controllerButtonUp.png")
        $Player1Controls/ReturnKey.texture = load("res://screens/info_screen/controllerButtonStart.png")
