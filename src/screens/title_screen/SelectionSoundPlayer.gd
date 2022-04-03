extends AudioStreamPlayer


onready var settings = get_node("/root/Settings")

func _on_button_entered():
    if settings.sfx_enabled:
	    self.play()
