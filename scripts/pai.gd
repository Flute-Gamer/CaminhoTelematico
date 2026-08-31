extends Node3D

@export var useLocalMicrophone = true

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
var wait = false

#colors
var bands = 7
@export var minFreq = 20.0
@export var maxFreq = 20000.0
var factor
var spectrum
var magnitude = []
var index_color = 0

var isWireframe = false

@onready var oscReceiverPitch = $OSCReceiverPitch
@onready var oscReceiverVolume = $OSCReceiverVolume

func _ready() -> void:
	speedArray.resize(array_size)
	for i in range(speedArray.size()):
		speedArray[i] = 0.1
		
	magnitude.resize(bands)
	set_frequencies(maxFreq, minFreq)
	
	if useLocalMicrophone:
		record_live_index = AudioServer.get_bus_index('Record')
		spectrum = AudioServer.get_bus_effect_instance(record_live_index, 1)

func _process(_delta: float) -> void:
	calculateIndexColor()
	if Input.is_action_just_pressed("Stop"):
		stopped = !stopped
	if Input.is_action_just_pressed("Wireframe"):
		isWireframe = !isWireframe
		if isWireframe:
			get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
		else:
			get_viewport().debug_draw = Viewport.DEBUG_DRAW_DISABLED
	var sample: float
	if useLocalMicrophone:
		sample = db_to_linear(AudioServer.get_bus_peak_volume_left_db(record_live_index, 0))
		handleSpeed(sample)
		return
	sample = oscReceiverVolume.value
	handleSpeed(sample)
	
func handleSpeed(sample: float):
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
	
func controlSpeed(momspeed: float):
	if (index < array_size):
		pass
	else:
		index = 0
	speedArray[index] = momspeed
	index = index + 1
	return	
	
func calculateIndexColor():
	if useLocalMicrophone:
		for i in range(bands):
			if factor != null:
				var aud = spectrum.get_magnitude_for_frequency_range(
					minFreq*pow(factor, i), 
					minFreq*pow(factor, i+1))
				magnitude[i] = max(aud.x, aud.y)
		index_color = maxIndex(magnitude)	
		return 
	else:
		if oscReceiverPitch == null:
			return 0
		var freq = oscReceiverPitch.value
		for i in range(bands):
			var low = minFreq * pow(factor, i)
			var high = minFreq * pow(factor, i + 1)
			if freq >= low and freq < high:
				index_color = i
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

func set_input_mode(local_microphone: bool):
	useLocalMicrophone = local_microphone
	return

func set_frequencies(maxfreq: float, minfreq: float):
	maxFreq = maxfreq
	minFreq = minfreq
	factor = pow(maxfreq/minfreq, 1.0/bands)
	return
