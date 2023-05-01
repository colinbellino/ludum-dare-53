extends Node

@export var templates : Array[WaveTemplate] = []
@export var checkpoint_wave : Wave

func generate_waves(difficulty:float, length := 60.0):
	var filtered_templates = templates.filter(
		func(template:WaveTemplate):
			return difficulty > template.min_difficulty and difficulty < template.max_difficulty
	)
	var weight_map = {}
	for template in filtered_templates:
		weight_map[template] = template.calculate_weight(difficulty)
	
	var waves : WaveList = WaveList.new()
	var total_length = 0
	while total_length < length:
		var template = Utils.rand_element_weighted(weight_map)
		var wave = template.generate_wave(difficulty)
		total_length += wave.total_wave_time
		waves.waves.append(wave)
	waves.waves.append(checkpoint_wave)
	return waves
