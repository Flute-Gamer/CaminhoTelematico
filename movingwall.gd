extends MeshInstance3D

#variaveis pra andar
const MAX_SAMPLES: int = 10
var grandParent
var speed = 0.5
var volume_samples: Array = []
var initialX = 100
var speedArray: Array = []
var index: int = 0
var momentspeed: float
const array_size = 1500

#variaveis pra luz
var record_live_index: int
var record_bus_index
var spectrum
@export var minFreq = 20.0
@export var maxFreq = 5000.0
var bands = 7
var factor
var magnitude = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#ready para andar
	grandParent = get_parent().get_parent().get_parent()
	visible = false
	
	record_live_index = AudioServer.get_bus_index('Record')
	
	speedArray.resize(array_size)
	for i in range(speedArray.size()):
		speedArray[i] = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if position.x < -20:
		position.x = initialX
		
	if position.x > 85:
		visible = false
	else:
		visible = true
	
	var sample = db_to_linear(AudioServer.get_bus_peak_volume_left_db(record_live_index, 0))
	volume_samples.push_front(sample)
	if volume_samples.size() > MAX_SAMPLES:
		volume_samples.pop_back()
		
	var sample_avg = average_array(volume_samples)
	
	momentspeed = sample_avg * 10
	controlSpeed(momentspeed)
	speed = average_array(speedArray)
	
	if speed < 0.1:
		speed = 0.1
		
	position.x += -speed * delta
	
func controlSpeed(momspeed: float):
	if (index < array_size):
		pass
	else:
		index = 0
	speedArray[index] = momspeed
	index = index + 1
	return
	
func maxIndex(arr):
	var maxindex = 0
	for i in range (1, arr.size()):
		if arr[i] > arr[maxindex]:
			maxindex = i
	return maxindex
	
	
func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg
