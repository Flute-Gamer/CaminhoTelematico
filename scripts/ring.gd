extends MeshInstance3D
var speed = 0.02
var Parent
var isVisible = true
var turnRight = true

func _ready() -> void:
	Parent = get_parent()
	if self.scale.x < 1:
		return
	else:
		turnRight = false
		return

func _process(delta: float) -> void:
	self.visible = isVisible
	if Input.is_action_just_pressed("RevealDisc"):
		isVisible = !isVisible
		
	speed = Parent.speed
	if speed < 0.1:
		speed = 0.1
	if turnRight:
		rotation.x += speed/4 * delta
		scale = Vector3(speed*0.15, speed*0.15, speed*0.15)
		if scale < Vector3(0.15, 0.15, 0.15):
			scale = Vector3(0.15, 0.15, 0.15)
	else:
		rotation.x += 1.618 * -speed/4 * delta
		scale = Vector3(speed*0.3, speed*0.3, speed*0.3)
		if scale < Vector3(0.3, 0.3, 0.3):
			scale = Vector3(0.3, 0.3, 0.3)
