class_name MobSpawner extends CanvasLayer

var spawn_area : ColorRect

signal wave_over(wave, index)
signal all_waves_over()

func _ready():
	spawn_area = get_node("%Spawn Area")
	spawn_area.visible = false
	assert(spawn_area != null, "Missing spawn_area from MobSpawner.")

# Notes: this is weird but we MUST have a wave with is_checkpoint to true at the end or the game will crash
func start_wave(waves, wave_index):
	print("Wave " + str(wave_index) + " starting --------------------------")

	while true:
		var wave = waves[wave_index]
		# var wave = waves.pop_front()
		for mob_scene in wave.mobs:
			spawn_mob(mob_scene, wave)
			await get_tree().create_timer(wave.mob_timer).timeout

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
	print(" - Spawning mob: ", mob.name, " at ", mob.position)
	add_child(mob)

	var mob_size = mob.collision_shape.shape.get_rect().size

	var position : Vector2 = Vector2.ZERO

	# TODO: When we want different spawn patterns, add them here :)
	match wave.spawn_pattern:
		Wave.SpawnPatterns.RandomSide:
			position.y = randf_range(100, spawn_area.get_size().y - 200)
			if randi_range(0, 1) > 0:
				position.x = spawn_area.get_size().x + mob_size.x / 2
			else:
				position.x = - mob_size.x / 2

		Wave.SpawnPatterns.TopCenter:
			position.x = spawn_area.get_size().x / 2
			position.y = -mob_size.y / 2


	mob.position = position

	return mob
