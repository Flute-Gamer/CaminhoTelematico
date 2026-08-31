extends CheckButton

@onready var pai = get_tree().root.get_node("World/Pai")

func _on_toggled(toggled_on):
	if toggled_on:
		pai.set_frequencies(2000.0, 261.0)
	else:
		pai.set_frequencies(20000.0, 20.0)
