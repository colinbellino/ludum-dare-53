@tool
class_name Wave extends Resource

@export var repeat_n_times : int = 1
## In seconds
@export var mob_timer : float = 0.9
@export var wait_timer : float = 0.1
@export var spawn_pattern : SpawnPatterns
@export var mobs : Array[PackedScene]
@export var is_checkpoint : bool
@export var total_wave_time : float:
	get: return mob_timer * repeat_n_times + wait_timer

enum SpawnPatterns { RandomSide, TopCenter }
