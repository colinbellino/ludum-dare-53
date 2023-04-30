class_name LevelChunk extends Node

var checkpoint : Checkpoint
var mob_spawner : MobSpawner

func _ready():
	checkpoint = get_node("Checkpoint")
	assert(checkpoint != null, "Missing checkpoint from LevelChunk.")

	mob_spawner = get_node("MobSpawner")
	assert(mob_spawner != null, "Missing mob_spawner from LevelChunk.")
