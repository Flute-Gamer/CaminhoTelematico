extends MeshInstance3D
var speed = 0.02
var Parent

func _ready() -> void:
	Parent = get_parent()

func _process(delta: float) -> void:
	
	speed = Parent.speed
	
	if speed < 0.1:
		speed = 0.1
	rotation.y += speed * delta
		
	scale = Vector3(speed*0.2, speed*0.2, speed*0.2)
	if scale < Vector3(0.15, 0.15, 0.15):
		scale = Vector3(0.15, 0.15, 0.15)
		
