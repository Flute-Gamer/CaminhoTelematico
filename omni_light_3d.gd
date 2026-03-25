extends OmniLight3D

#variaveis pra girar
var grandParent
var angle
var radius
var speed = 2

#variaveis pra luz
var record_live_index: int
var record_bus_index
var spectrum
var minFreq = 20.0
var maxFreq = 3000.0
var bands = 7
var factor
var magnitude = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#ready para girar
	grandParent = get_parent().get_parent()
	var offset = global_position - grandParent.global_position
	radius = offset.length()
	angle = atan2(offset.y, offset.z)
	
	#ready para luz
	randomize()
	magnitude.resize(bands)
	record_live_index = AudioServer.get_bus_index('Record')
	spectrum = AudioServer.get_bus_effect_instance(record_live_index, 1)
	factor = pow(maxFreq/minFreq, 1.0/bands)
	color()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	angle += speed * delta
	var new_y = -cos(angle) * radius
	var new_z = sin(angle) * radius
	global_position = grandParent.global_position + Vector3(0, new_y, new_z)
	
	##print(magnitude)
	##var energy = magnitude.length()
	##light_energy = energy * 10.0

func color():
	for i in range(bands):
		var aud = spectrum.get_magnitude_for_frequency_range(minFreq*pow(factor, i), minFreq*pow(factor, i+1))         
		magnitude[i] = (aud.x + aud.y)/2
	var index = maxIndex(magnitude)
	if index == 0:
		self.light_color = Color(1, 0, 0)
	elif index == 1:
		self.light_color = Color(1, 0.5, 0) 
	elif index == 2:
		self.light_color = Color(1, 1, 0)
	elif index == 3:
		self.light_color = Color(0, 1, 0)
	elif index == 4:
		self.light_color = Color(0.0, 0.7,1)
	elif index == 5:
		self.light_color = Color(0, 0, 1)
	else:
		self.light_color = Color(0.56, 0, 1)
		
	var waitTime = randf_range(0.5, 5.0)
	await get_tree().create_timer(waitTime).timeout
	color()
	
	return
	
func maxIndex(arr):
	var maxindex = 0
	for i in range (1, arr.size()):
		if arr[i] > arr[maxindex]:
			maxindex = i
	return maxindex
	
