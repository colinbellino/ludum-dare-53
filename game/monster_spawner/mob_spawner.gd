extends Node2D

@export var waves : Array[Wave]

func _ready():
	while waves.size() > 0:
		var wave = waves.pop_front()
		for mob in wave.mobs:
			var spawn_rect = get_viewport().get_visible_rect()
			var enemy = mob.EnemyScenesLookup[mob.monster].instantiate()
			enemy.position = mob.spawn_position(spawn_rect)
			add_child(enemy)
			await get_tree().create_timer(wave.mob_timer).timeout
		await get_tree().create_timer(wave.wave_over_timer).timeout
