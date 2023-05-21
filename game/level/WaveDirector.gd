class_name WaveDirector extends Node

@export var templates : Array[WaveTemplate] = []
@export var checkpoint_wave : Wave

func generate_waves(base_difficulty: float, length : float = 60.0) -> WaveList:
	var waves : WaveList = WaveList.new()
	var total_length = 0
	while total_length < length:
		var cur_difficulty = base_difficulty + total_length / length * 2.0
		var filtered_templates = templates.filter(
			func(template:WaveTemplate):
				return cur_difficulty > template.min_difficulty and cur_difficulty < template.max_difficulty
		)
		var weight_map = {}
		for template in filtered_templates:
			weight_map[template] = template.calculate_weight(cur_difficulty)
		var template = Utils.rand_element_weighted(weight_map)
		var wave = template.generate_wave(cur_difficulty)
		total_length += wave.total_wave_time
		waves.waves.append(wave)
	waves.waves.append(checkpoint_wave)
	return waves
