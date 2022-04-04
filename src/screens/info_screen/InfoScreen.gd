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
        if event.is_action_type() and not event.is_pressed():
            prints(self, 'Any key was pressed')
            emit_signal("start_game")


func show():
    # Show the screen
    visible = true

    var joypad_count = Input.get_connected_joypads().size()
    if joypad_count > 0:
        $Player2Controls.visible = joypad_count == 1
        $Player1Controls/P1ControlsLabel.text = 'Controls'
        $Player1Controls/EscKey.texture = load("res://screens/info_screen/blackPixel.png")
        $Player1Controls/BackToMenuSpacer2.texture = load("res://screens/info_screen/controllerButtonSelect.png")
        $Player1Controls/WKey.texture = load("res://screens/info_screen/dpadUp.png")
        $Player1Controls/QKey.texture = load("res://screens/info_screen/controllerButtonLeft.png")
        $Player1Controls/EKey.texture = load("res://screens/info_screen/controllerButtonDown.png")
        $Player1Controls/AKey.texture = load("res://screens/info_screen/dpadLeft.png")
        $Player1Controls/DKey.texture = load("res://screens/info_screen/dpadRight.png")
        $Player1Controls/SKey.texture = load("res://screens/info_screen/dpadDown.png")
        $Player1Controls/SpaceBar.texture = load("res://screens/info_screen/controllerButtonRight.png")
