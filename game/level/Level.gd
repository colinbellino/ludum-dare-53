class_name Level extends Node

var world : Node2D
var cart : Cart
var state : LevelStates
var chunks : Array[Node]
var current_chunk_index : int = 0
var current_chunk : LevelChunk
var checkpoint_ui : CheckpointUI

enum LevelStates { INIT, MOVING, CHECKPOINT }

func _ready():
	world = get_node("%World")
	assert(world != null, "Missing world from level.")

	cart = get_node("%Cart")
	assert(cart != null, "Missing cart from level.")

	chunks = get_tree().get_nodes_in_group("level_chunk")
	assert(chunks.size() > 0, "No level chunks found, make sure you tagged your level with the level_chunk group.")
	# for node in chunks:
	# 	var chunk : LevelChunk = node

	start_chunk(0)

	checkpoint_ui = get_node("%CheckpointUI")
	assert(checkpoint_ui != null, "Missing checkpoint_ui from level.")
	checkpoint_ui.connect("continue_pressed", on_checkpoint_continue_pressed)
	checkpoint_ui.close()

	GameData.level = self

	state = LevelStates.MOVING

func _exit_tree():
	GameData.level = null

func _process(delta: float):
	if OS.is_debug_build() && Input.is_action_just_released("ui_cancel"):
		get_tree().quit()
	if OS.is_debug_build():
		if Input.is_key_pressed(KEY_SHIFT):
			Engine.set_time_scale(20)
		else:
			Engine.set_time_scale(1)

	match state:
		LevelStates.INIT:
			pass

		LevelStates.MOVING:
			# world.position -= cart.movement_speed * delta * speed_multiplier
			cart.position += cart.movement_speed * delta

		LevelStates.CHECKPOINT:
			pass

func checkpoint_reached():
	var next_index := current_chunk_index + 1
	if next_index > chunks.size() - 1:
		print("End of the game reached!")
		Overlay.transition("res://game/main_menu/TitleUI.tscn")
		return

	print("Checkpoint reached!")
	checkpoint_ui.open("Checkpoint " + str(current_chunk_index))
	state = LevelStates.CHECKPOINT

func on_checkpoint_continue_pressed():
	checkpoint_ui.close()
	var next_index := current_chunk_index + 1
	start_chunk(next_index)
	state = LevelStates.MOVING

func start_chunk(index: int):
	if current_chunk != null:
		current_chunk.checkpoint.disconnect("reached", checkpoint_reached)
	current_chunk_index = index
	current_chunk = chunks[current_chunk_index] as LevelChunk
	current_chunk.checkpoint.connect("reached", checkpoint_reached)
	current_chunk.mob_spawner.start_wave()
