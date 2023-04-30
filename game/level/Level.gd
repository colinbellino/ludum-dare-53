class_name Level extends Node

var cart : Cart
var state : LevelStates
var chunks : Array[Node]
var current_chunk_index : int = 0
var current_chunk : LevelChunk
var checkpoint_ui : CheckpointUI

enum LevelStates { INIT, MOVING, CHECKPOINT }

func _ready():
	cart = get_node("%Cart")
	assert(cart != null, "Missing cart from level.")

	chunks = get_tree().get_nodes_in_group("level_chunk")
	assert(chunks.size() > 0, "No level chunks found, make sure you tagged your level with the level_chunk group.")
	# for node in chunks:
	# 	var chunk : LevelChunk = node

	connect_chunk_events(0)

	checkpoint_ui = get_node("%CheckpointUI")
	assert(checkpoint_ui != null, "Missing checkpoint_ui from level.")
	checkpoint_ui.connect("continue_pressed", on_checkpoint_continue_pressed)
	checkpoint_ui.close()

	state = LevelStates.MOVING

func _process(delta: float):
	var speed_multiplier := 1
	if OS.is_debug_build() && Input.is_action_just_released("ui_cancel"):
		get_tree().quit()
	if OS.is_debug_build() && Input.is_key_pressed(KEY_SHIFT):
		speed_multiplier = 20

	match state:
		LevelStates.INIT:
			pass

		LevelStates.MOVING:
			cart.position += cart.movement_speed * delta * speed_multiplier

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
	connect_chunk_events(next_index)
	state = LevelStates.MOVING

func connect_chunk_events(index: int):
	if current_chunk != null:
		current_chunk.checkpoint.disconnect("reached", checkpoint_reached)
	current_chunk_index = index
	current_chunk = chunks[current_chunk_index] as LevelChunk
	current_chunk.checkpoint.connect("reached", checkpoint_reached)
