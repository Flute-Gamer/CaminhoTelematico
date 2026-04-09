extends Node3D
var speed = 0.02
var record_live_index: int
var volume_samples: Array = []
var speedArray: Array = []
var index: int = 0
var momentspeed: float
const array_size = 1500
const MAX_SAMPLES: int = 10

func _ready() -> void:
	record_live_index = AudioServer.get_bus_index('Record')
	speedArray.resize(array_size)
	for i in range(speedArray.size()):
		speedArray[i] = 0.1

func _process(_delta: float) -> void:
	var sample = db_to_linear(AudioServer.get_bus_peak_volume_left_db(record_live_index, 0))
	volume_samples.push_front(sample)
	if volume_samples.size() > MAX_SAMPLES:
		volume_samples.pop_back()
	var sample_avg = average_array(volume_samples)
	
	momentspeed = sample_avg * 10
	controlSpeed(momentspeed)
	speed = average_array(speedArray)
	
func controlSpeed(momspeed: float):
	if (index < array_size):
		pass
	else:
		index = 0
	speedArray[index] = momspeed
	index = index + 1
	return	
	
func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg
