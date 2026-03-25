extends VBoxContainer

const MAX_SAMPLES: int = 10
var record_live_index: int
var volume_samples: Array = []

func _ready() -> void:
	record_live_index = AudioServer.get_bus_index('Record')

func _process(delta: float) -> void:
	var sample = db_to_linear(AudioServer.get_bus_peak_volume_left_db(record_live_index, 0))
	volume_samples.push_front(sample)

	if volume_samples.size() > MAX_SAMPLES:
		volume_samples.pop_back()

	var sample_avg = average_array(volume_samples)
	#print('%sdb' % round(linear_to_db(sample_avg)))

func average_array(arr: Array) -> float:
	var avg = 0.0
	for i in range(arr.size()):
		avg += arr[i]
	avg /= arr.size()
	return avg
