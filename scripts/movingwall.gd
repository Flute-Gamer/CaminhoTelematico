extends MeshInstance3D

var grandParent
var speed = 0.5
var initialX = 100
const array_size = 1500

func _ready() -> void:
	#ready para andar
	grandParent = get_parent().get_parent()
	visible = false

func _process(delta: float) -> void:
	if position.x < -20:
		position.x = initialX
	if position.x > 85:
		visible = false
	else:
		visible = true
	
	speed = grandParent.speed * 4
	
	if speed < 0.1:
		speed = 0.1
		
	position.x += -speed * delta
