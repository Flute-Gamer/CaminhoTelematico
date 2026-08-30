extends Node3D

@onready var pause_menu = $CanvasLayer/Menu

func _ready():
	pause_menu.hide()

func _input(event):
	if event.is_action_pressed("Menu"):
		pause_menu.visible = !pause_menu.visible
