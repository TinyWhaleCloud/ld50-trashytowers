extends AudioStreamPlayer

func _on_button_entered():
    if Settings.sfx_enabled:
        self.play()
