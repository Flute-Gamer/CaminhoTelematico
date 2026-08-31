extends CheckButton

@onready var pai = get_tree().root.get_node("World/Pai")
@onready var osc_button = $"../MicrofoneOSC"

func _ready():
	button_pressed = pai.useLocalMicrophone

func _on_toggled(toggled_on):
	if toggled_on:
		pai.set_input_mode(true)
		osc_button.button_pressed = false
	else:
		pai.set_input_mode(false)
		osc_button.button_pressed = true
