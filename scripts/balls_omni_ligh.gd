extends OmniLight3D

#variaveis pra girar
const MAX_SAMPLES: int = 10
var grandParent
var angle
var radius
var speed = 0.01
var globalZ = 0
var volume_samples: Array = []
var isVisible = true

func _ready() -> void:
	#ready para girar
	grandParent = get_parent().get_parent()
	var offset = global_position - grandParent.global_position
	radius = offset.length()
	
	if global_position.z == 0:
		angle = atan2(offset.y, offset.x)
	else:
		globalZ = 1
		angle = atan2(offset.y, offset.z)
	
	#ready para luz
	randomize()
	color()

func _process(delta: float) -> void:
	speed = grandParent.speed	
	if speed < 0.05:
		speed = 0.05
	angle += speed * delta
	
	self.visible = isVisible
	if Input.is_action_just_pressed("RevealBalls"):
		isVisible = !isVisible
	
	if globalZ == 0:
		var new_x = -cos(angle) * radius
		var new_y = sin(angle) * radius
		global_position = grandParent.global_position + Vector3(new_x, new_y, 0)
	else:
		var new_y = -cos(angle) * radius
		var new_z = sin(angle) * radius
		global_position = grandParent.global_position + Vector3(0, new_y, new_z)
	
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
		
	var waitTime = randf_range(0.5, 8.0)
	await get_tree().create_timer(waitTime).timeout
	color()
	
	return	
