class_name WaveTemplate extends Resource

@export var min_difficulty : float = 0.0
@export var mid_difficulty : float = 5.0
@export var max_difficulty : float = 10.0
@export var selection_weight_at_min : float = 1.0
@export var selection_weight_at_mid : float = 1.0
@export var selection_weight_at_max : float = 1.0
@export var repeat_n_times_base : int = 1
@export var repeat_increase_per_difficulty : float = 0.25
@export var repeat_randomness : int = 0
@export var mob_timer : float = 0.5 ## In seconds
@export var mob_timer_increase_per_difficulty : float = -0.1
@export var mob_timer_floor = 0.05
@export var wait_timer : float = 0.5
@export var wait_timer_increase_per_difficulty : float = -0.05
@export var wait_timer_floor = 0.05
@export var skip_chance : float = 0.0
@export var spawn_pattern : Wave.SpawnPatterns
@export var mobs : Array[PackedScene]

func calculate_weight(difficulty: float) -> float:
	if difficulty < mid_difficulty:
		return remap(difficulty, min_difficulty, mid_difficulty, selection_weight_at_min, selection_weight_at_mid)
	return remap(difficulty, mid_difficulty, max_difficulty, selection_weight_at_mid, selection_weight_at_max)

func generate_wave(difficulty: float) -> Wave:
	var wave = Wave.new()
	wave.mob_timer = max(mob_timer + mob_timer_increase_per_difficulty * difficulty, mob_timer_floor)
	wave.repeat_n_times = roundi(repeat_n_times_base + repeat_increase_per_difficulty * difficulty + randi_range(0, repeat_randomness))
	wave.mobs = mobs
	wave.is_checkpoint = false
	wave.wait_timer = max(wait_timer + wait_timer_increase_per_difficulty * difficulty, wait_timer_floor)
	wave.skip_chance = skip_chance
	return wave
