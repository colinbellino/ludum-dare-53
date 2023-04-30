class_name MobSpawner extends CanvasLayer

@export var waves : Array[Wave]

var spawn_area : ColorRect

func _ready():
	spawn_area = get_node("%Spawn Area")
	spawn_area.visible = false
	assert(spawn_area != null, "Missing spawn_area from MobSpawner.")

func start_wave():
	print("Wave starting...")
	while waves.size() > 0:
		var wave = waves.pop_front()
		for mob_scene in wave.mobs:
			var mob := spawn_position(mob_scene)
			add_child(mob)
			print("Spawning mob: ", mob.name, mob.position)

			await get_tree().create_timer(wave.mob_timer).timeout

		await get_tree().create_timer(wave.wave_over_timer).timeout
		print("Wave over")

func spawn_position(mob_scene) -> Mob:
	var mob = mob_scene.instantiate() as Mob
	assert(mob != null)

	var position : Vector2 = Vector2.ZERO

	if randi_range(0, 1) > 0:
		position.x = spawn_area.get_size().x
	else:
		position.x = -spawn_area.get_size().x

	mob.position = position

	return mob
