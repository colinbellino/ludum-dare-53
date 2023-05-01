class_name Wave extends Resource

const MOB_TIMER_DEFAULT = 1.0
const WAVE_TIMER_DEFAULT = 10.0

@export var repeat_n_times : int = 1
## In seconds
@export var mob_timer : float = 1.0
@export var spawn_pattern : SpawnPatterns
@export var mobs : Array[PackedScene]
@export var is_checkpoint : bool

enum SpawnPatterns { RandomSide, TopCenter }
