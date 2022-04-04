extends Panel


func _unhandled_input(event: InputEvent) -> void:
    if visible:
        # Unpause the game if any key is pressed
        if (event is InputEventKey or event is InputEventJoypadButton) and event.is_pressed():
            get_tree().set_input_as_handled()
            prints(self, 'Any key was pressed')
            visible = false
            get_tree().paused = false
