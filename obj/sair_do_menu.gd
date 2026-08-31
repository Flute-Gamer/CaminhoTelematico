extends Button

func _on_pressed():
	get_tree().current_scene.get_node("CanvasLayer/Menu").hide()


func _on_microfone_sistema_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.
