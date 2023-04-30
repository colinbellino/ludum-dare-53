extends Resource
class_name Wave

const MOB_TIMER_DEFAULT = 1.0
const WAVE_TIMER_DEFAULT = 10.0

@export var mob_timer : float = MOB_TIMER_DEFAULT
@export var wave_over_timer : float = WAVE_TIMER_DEFAULT
@export var mobs : Array[PackedScene]
