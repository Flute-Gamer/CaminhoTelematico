extends MeshInstance3D
var speed = 0.02
var record_live_index: int
var volume_samples: Array = []
const MAX_SAMPLES: int = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	record_live_index = AudioServer.get_bus_index('Record')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var sample = db_to_linear(AudioServer.get_bus_peak_volume_left_db(record_live_index, 0))
	volume_samples.push_front(sample)
	if volume_samples.size() > MAX_SAMPLES:
		volume_samples.pop_back()
	var sample_avg = average_array(volume_samples)
	
	speed = sample_avg * 3
	if speed < 0.025:
		speed = 0.025
	rotation.y += speed * delta
	pass

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
