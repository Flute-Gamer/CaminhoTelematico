extends Node3D
#movement
var speed = 0.02
var record_live_index: int
var volume_samples: Array = []
var speedArray: Array = []
var index: int = 0
var momentspeed: float
const array_size = 1000
const MAX_SAMPLES: int = 10
var stopped = false

#colors
var bands = 7
@export var minFreq = 20.0
@export var maxFreq = 5000.0
var factor
var spectrum
var magnitude = []

func _ready() -> void:
	record_live_index = AudioServer.get_bus_index('Record')
	speedArray.resize(array_size)
	for i in range(speedArray.size()):
		speedArray[i] = 0.1
		
	magnitude.resize(bands)
	record_live_index = AudioServer.get_bus_index('Record')
	spectrum = AudioServer.get_bus_effect_instance(record_live_index, 1)
	factor = pow(maxFreq/minFreq, 1.0/bands)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Stop"):
		stopped = true
	var sample = db_to_linear(AudioServer.get_bus_peak_volume_left_db(record_live_index, 0))
	volume_samples.push_front(sample)
	if volume_samples.size() > MAX_SAMPLES:
		volume_samples.pop_back()
	var sample_avg = average_array(volume_samples)
	if stopped:
		if sample_avg < 0.1:
			for i in range(speedArray.size()):
				speedArray[i] *= 0.99
			speed = average_array(speedArray)
		return
	momentspeed = sample_avg * 10
	controlSpeed(momentspeed)
	speed = average_array(speedArray)
	
func indexColor():
	for i in range(bands):
		if factor != null:
			var aud = spectrum.get_magnitude_for_frequency_range(minFreq*pow(factor, i), minFreq*pow(factor, i+1))         
			magnitude[i] = (aud.x + aud.y)/2
	var index_color = maxIndex(magnitude)
	return index_color
	
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
	
func maxIndex(arr):
	var maxindex = 0
	for i in range (1, arr.size()):
		if arr[i] > arr[maxindex]:
			maxindex = i
	return maxindex
	
