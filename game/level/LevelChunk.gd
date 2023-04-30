class_name LevelChunk extends Node

var checkpoint : Checkpoint
var cart : Cart

func _ready():
	checkpoint = get_node("Checkpoint")
	assert(checkpoint != null, "Missing checkpoint from level.")
