class_name MobSpawner extends CanvasLayer

@export var waves : Array[Wave]

var spawn_area : ColorRect

func _ready():
	spawn_area = get_node("%Spawn Area")
	spawn_area.visible = false
	assert(spawn_area != null, "Missing spawn_area from MobSpawner.")

	while waves.size() > 0:
		var wave = waves.pop_front()
		for mob in wave.mobs:
			var spawn_rect = get_viewport().get_visible_rect()
			var mob_node = mob.EnemyScenesLookup[mob.monster].instantiate()
			mob_node.position = spawn_position(mob_node)
			add_child(mob_node)
			print("Spawning mob: ", mob_node.name, mob_node.position)

			await get_tree().create_timer(wave.mob_timer).timeout

		await get_tree().create_timer(wave.wave_over_timer).timeout
		print("Wave over")


func spawn_position(mob_node: Monster) -> Vector2:
	var position : Vector2 = Vector2.ZERO

	if randi_range(0, 1) > 0:
		position.x = spawn_area.get_size().x
	else:
		position.x = -spawn_area.get_size().x

	return position
