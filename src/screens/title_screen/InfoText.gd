extends RichTextLabel

var default_text = 'Select a mode to play'
var single_player_text = 'Try to beat your high score by placing trash in a can. Amazing!'
var hotseat_text = 'Take turns placing trash in the can with your friends. Who could imagine a better thing to do?'
var chaos_text = 'A chaotic mode where two or more players try placing trash in the can at the same time'

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