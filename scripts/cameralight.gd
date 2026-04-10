extends OmniLight3D

var grandParent

func _ready() -> void:	
	#ready para luz
	grandParent = get_parent().get_parent()
	randomize()
	color()

func _process(_delta: float) -> void:
	pass
	
func color():
	var index_color = grandParent.indexColor()
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
		
	var waitTime = randf_range(0.5, 5.0)
	await get_tree().create_timer(waitTime).timeout
	color()
	
	return	
