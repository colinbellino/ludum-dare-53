class_name Level extends Node

var ship : Ship
var state : LevelStates
var chunks : Array[Node]
var checkpoint_ui : CheckpointUI
var checkpoint_index : int = 1
var wave_index : int

@export var waves : WaveList

var CHECKPOINT_WAVE_DELAY := 10

enum LevelStates { MOVING, CHECKPOINT, GAME_OVER }

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

		if OS.is_debug_build():
			if Input.is_key_pressed(KEY_SHIFT):
				Engine.set_time_scale(20)
			else:
				Engine.set_time_scale(1)

	match state:
		LevelStates.MOVING:
			ship.movement_mult = 1.0

		LevelStates.CHECKPOINT:
			ship.movement_mult = 0.0

		LevelStates.GAME_OVER:
			ship.movement_mult = 0.0

func on_wave_over(wave, index):
	wave_index = index + 1

	if wave_index > waves.waves.size() - 1:
		print("End of the game reached!")
		Overlay.transition("res://game/main_menu/TitleUI.tscn")
		return

	if wave.is_checkpoint:
		checkpoint_ui.open("Checkpoint #" + str(checkpoint_index))
		state = LevelStates.CHECKPOINT

func on_checkpoint_continue_pressed():
	checkpoint_ui.close()
	checkpoint_index += 1;

	state = LevelStates.MOVING

	await get_tree().create_timer(CHECKPOINT_WAVE_DELAY).timeout
	%MobSpawner.start_wave(waves.waves, wave_index)

func on_cargo_destroyed(_cargo: Cargo):
	var all_cargo_destroyed := is_all_cargo_destroyed()
	print("all_cargo_destroyed: ", all_cargo_destroyed)

	if all_cargo_destroyed:
		state = LevelStates.GAME_OVER

		var center = ship.position

		for i in range(10):
			var count := i * 2 - 2
			for y in range(max(1, count)):
				var position = Vector2(
					randi_range(center.x - 60, center.x + 60),
					randi_range(center.y - 60, center.y + 60)
				)
				FxSpawner.spawn_fx(preload("res://game/fx/explosion_1.tscn"), position)
				await get_tree().create_timer(0.02).timeout
			await get_tree().create_timer(0.2).timeout

		Overlay.show_modal(preload("res://game/main_menu/GameOverUI.tscn"))

func is_all_cargo_destroyed() -> bool:
	var cargo := 0
	var cargo_destroyed := 0
	for node in ship.get_tree().get_nodes_in_group("Selectable"):
		if ship.is_ancestor_of(node) and node is ShipSlot:
			if node.current_structure_node && node.current_structure_node is Cargo:
				cargo += 1
				if node.current_structure_node.hitpoints <= 0:
					cargo_destroyed += 1

	return cargo > 0 && cargo == cargo_destroyed
