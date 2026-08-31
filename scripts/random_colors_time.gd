extends CheckButton

@onready var pai = get_tree().root.get_node("World/Pai")

func _on_toggled(toggled_on):
	if toggled_on:
		pai.wait = true
	else:
		pai.wait = false
