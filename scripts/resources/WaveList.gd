@tool
class_name WaveList
extends Resource

@export var waves : Array[Wave]

func total_length()->float:
	var accum = 0.0
	for wave in waves:
		accum += wave.total_wave_time
	return accum
