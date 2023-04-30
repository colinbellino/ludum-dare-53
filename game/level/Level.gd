class_name Level extends Node

var ship : Ship
var state : LevelStates
var chunks : Array[Node]
var checkpoint_ui : CheckpointUI
var checkpoint_index : int = 1
var wave_index : int

@export var waves : WaveList

enum LevelStates { MOVING, CHECKPOINT }

func _ready():
	ship = get_node("%Ship")
	assert(ship != null, "Missing ship from level.")

	checkpoint_ui = get_node("%CheckpointUI")
	assert(checkpoint_ui != null, "Missing checkpoint_ui from level.")
	checkpoint_ui.connect("continue_pressed", on_checkpoint_continue_pressed)
	checkpoint_ui.close()

	%MobSpawner.connect("wave_over", on_wave_over)
	%MobSpawner.start_wave(waves.waves, wave_index)

	GameData.level = self

func _exit_tree():
	GameData.level = null

func _process(_delta: float):
	if OS.is_debug_build():
		if Input.is_action_just_released("ui_cancel"):
			get_tree().quit()

		if Input.is_key_pressed(KEY_SHIFT):
			Engine.set_time_scale(20)
		else:
			Engine.set_time_scale(1)

	match state:
		LevelStates.MOVING:
			ship.movement_mult = 1.0

		LevelStates.CHECKPOINT:
			ship.movement_mult = 0.0

func on_wave_over(wave, index):
	wave_index = index + 1

	if wave_index > waves.size() - 1:
		print("End of the game reached!")
		Overlay.transition("res://game/main_menu/TitleUI.tscn")
		return

	if wave.is_checkpoint:
		checkpoint_ui.open("Checkpoint #" + str(checkpoint_index))
		state = LevelStates.CHECKPOINT

func on_checkpoint_continue_pressed():
	checkpoint_ui.close()
	checkpoint_index += 1;
	%MobSpawner.start_wave(waves.waves, wave_index)
	state = LevelStates.MOVING
