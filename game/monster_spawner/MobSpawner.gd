class_name MobSpawner extends Node2D

var level = null
@export var spawn_area : Rect2 = Rect2(Vector2(-960.0/2.0, -540.0/2.0), Vector2(960.0, 540.0))

signal wave_over(wave, index)
signal all_waves_over()

func _ready():
	level = find_parent("Level*")

# Notes: this is weird but we MUST have a wave with is_checkpoint to true at the end or the game will crash
func start_wave(waves, wave_index):
	print("Wave " + str(wave_index) + " starting --------------------------")

	while true:
		var wave = waves[wave_index]
		# var wave = waves.pop_front()
		var last_spawn_time = 0.0
		for mob_scene in wave.mobs:
			for i in wave.repeat_n_times:
				spawn_mob(mob_scene, wave)
				await get_tree().create_timer(wave.mob_timer * (i+1)).timeout

		await get_tree().create_timer(wave.wave_over_timer).timeout

		print("Wave " + str(wave_index) + " over     --------------------------")
		emit_signal("wave_over", wave, wave_index)
		wave_index += 1

		if wave.is_checkpoint:
			print("- Checkpoint reached!")
			break

	emit_signal("all_waves_over")

func spawn_mob(mob_scene: PackedScene, wave: Wave) -> Mob:
	if mob_scene == null:
		return

	var mob = mob_scene.instantiate() as Mob
	mob.name = mob_scene.resource_path.get_file().trim_suffix(".tscn")
	assert(mob != null)

	level.add_child(mob)
	var mob_size = mob.collision_shape.shape.get_rect().size * mob.collision_shape.scale

	var position : Vector2 = Vector2.ZERO

	# TODO: When we want different spawn patterns, add them here :)
	match wave.spawn_pattern:
		Wave.SpawnPatterns.RandomSide:
			position.y = randf_range(spawn_area.position.y, spawn_area.end.y)
			if randf() > 0.5:
				position.x = spawn_area.end.x + mob_size.x / 2
			else:
				position.x = spawn_area.position.x - mob_size.x / 2

		Wave.SpawnPatterns.TopCenter:
			position.x = spawn_area.get_center().x
			position.y = spawn_area.position.y - mob_size.y / 2
			print("mob_size: ", [mob_size])

	mob.global_position = position + global_position

	print(" - Spawning mob: %s at %s (pattern: %s)" % [mob.name, mob.global_position, wave.spawn_pattern])

	return mob
