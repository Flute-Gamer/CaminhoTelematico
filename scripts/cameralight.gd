extends OmniLight3D

var grandParent
var wait = false

func _ready() -> void:	
	#ready para luz
	grandParent = get_parent().get_parent()
	randomize()
	color_loop()

func _process(_delta: float) -> void:
	wait = grandParent.wait
	
func color_loop():
	while is_inside_tree():
		color()
		if wait:
			var waitTime = randf_range(0.5, 10.0)
			await get_tree().create_timer(waitTime).timeout
		else:
			await get_tree().process_frame
	
func color():
	var index_color = grandParent.index_color
	if index_color == 0:
		self.light_color = Color(1, 0, 0)
	elif index_color == 1:
		self.light_color = Color(1, 0.5, 0) 
	elif index_color == 2:
		self.light_color = Color(1, 1, 0)
	elif index_color == 3:
		self.light_color = Color(0, 1, 0)
	elif index_color == 4:
		self.light_color = Color(0.0, 0.7,1)
	elif index_color == 5:
		self.light_color = Color(0, 0, 1)
	else:
		self.light_color = Color(0.56, 0, 1)
	return	
