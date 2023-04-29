class_name Level extends Node

var checkpoint : Checkpoint
var cart : Cart
var state : LevelStates

enum LevelStates { INIT, MOVING, CHECKPOINT }

func _ready():
	checkpoint = get_node("%Checkpoint")
	assert(checkpoint != null, "Missing checkpoint from level.")
	checkpoint.connect("reached", checkpoint_reached)
	checkpoint.connect("continue_pressed", on_checkpoint_continue_pressed)
	checkpoint.ui_close()

	cart = get_node("%Cart")
	assert(cart != null, "Missing cart from level.")

	state = LevelStates.MOVING

func _process(delta: float):
	if OS.is_debug_build() && Input.is_action_just_released("ui_cancel"):
		get_tree().quit()

	match state:
		LevelStates.INIT:
			pass
		LevelStates.MOVING:
			cart.position += cart.movement_speed * delta
		LevelStates.CHECKPOINT:
			pass

func checkpoint_reached():
	print("Checkpoint reached!")
	checkpoint.ui_open()
	state = LevelStates.CHECKPOINT

func on_checkpoint_continue_pressed():
	print("CONTINUE!")
	checkpoint.ui_close()
	state = LevelStates.MOVING
