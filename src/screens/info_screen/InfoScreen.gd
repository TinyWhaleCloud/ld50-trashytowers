extends Node2D

func _ready():
    if Input.get_connected_joypads().size() > 0:
        $Player2Controls.visible = false
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
        # TODO: Hide P2 in single player and hotseat modes, change P1 controls heading in those modes to simply "Controls"

# TODO: switch to game after any key is pressed
