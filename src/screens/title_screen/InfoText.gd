extends RichTextLabel

var default_text = 'Select a mode to play'
var single_player_text = 'Try to beat your high score by placing trash in a can. Amazing!'
var hotseat_text = 'Take turns placing trash in the can with a friend. Whoever dropped the last piece of trash before it spills over looses.'
var chaos_text = 'A chaotic mode where two players try placing trash in the can at the same time. Whover dropped the last piece of trash before it spills over looses.'
var sfx_enabled_text = 'Toggle sound effects'
var music_enabled_text = 'Toggle music'

func _ready():
    show_default_text()

func _on_HotseatButton_mouse_entered():
	self.set_text(hotseat_text)

func _on_ChaosButton_mouse_entered():
	self.set_text(chaos_text)

func _on_SinglePlayerButton_mouse_entered():
    self.set_text(single_player_text)

func _on_HotseatButton_focus_entered():
	self.set_text(hotseat_text)

func _on_ChaosButton_focus_entered():
	self.set_text(chaos_text)

func _on_SinglePlayerButton_focus_entered():
	self.set_text(single_player_text)

func show_default_text():
    self.set_text(default_text)

func _on_SinglePlayerButton_focus_exited():
	show_default_text()

func _on_SinglePlayerButton_mouse_exited():
    show_default_text()

func _on_ChaosButton_focus_exited():
	show_default_text()

func _on_ChaosButton_mouse_exited():
	show_default_text()

func _on_HotseatButton_focus_exited():
	show_default_text()

func _on_HotseatButton_mouse_exited():
	show_default_text()

func _on_element_exited():
	show_default_text()

func _on_SoundEffectsChecked_entered():
	self.set_text(sfx_enabled_text)

func _on_MusicEnabled_entered():
	self.set_text(music_enabled_text)
