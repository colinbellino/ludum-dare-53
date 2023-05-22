@tool
class_name Wave extends Resource

@export var repeat_n_times : int = 1
@export var mob_timer : float = 0.9 ## In seconds
@export var wait_timer : float = 0.1
@export var skip_chance : float = 0.0
@export var spawn_pattern : SpawnPatterns
@export var mobs : Array[PackedScene]
@export var is_checkpoint : bool
@export var total_wave_time : float:
	get: return mob_timer * repeat_n_times * (mobs.size() * 1.0 - skip_chance) + wait_timer

enum SpawnPatterns { RandomSide, TopCenter }
