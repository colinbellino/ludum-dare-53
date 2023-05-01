class_name Level extends Node

var ship : Ship
var state : LevelStates
var chunks : Array[Node]
var checkpoint_ui : CheckpointUI
var checkpoint_index : int = 1
var wave_index : int

var last_checkpoint_cargo_worth = 0
var cargo_required = 50

@export var waves : WaveList

var CHECKPOINT_WAVE_DELAY := 25

enum LevelStates { TITLE, MOVING, CHECKPOINT, GAME_OVER }

func _ready():
	AudioPlayer.play_music(preload("res://assets/audio/ludum_title.ogg"))

	wave_index = 0
	var version = Utils.load_file("res://version.txt")
	print("version: ", version)

	%HUD.visible = false

	GameData.level = self
	GameData.money = GameData.STARTING_MONEY

	ship = get_node("%Ship")
	assert(ship != null, "Missing ship from level.")

	var title_node = Overlay.show_modal(preload("res://game/main_menu/TitleUI.tscn"), false)
	title_node.connect("tree_exited", start_game)

func start_game():
	if GameData.voice_played == false:
		AudioPlayer.play_sound(preload("res://assets/audio/voice_welcome_to_space_haulers.wav"))
		GameData.voice_played = true

	%HUD.visible = true

	%MobSpawner.connect("wave_over", on_wave_over)
	%MobSpawner.start_wave(waves.waves, wave_index)

	state = LevelStates.MOVING

func _exit_tree():
	GameData.level = null

func _process(_delta: float):
	if OS.is_debug_build():
		if Input.is_action_just_released("ui_cancel"):
			get_tree().quit()

		if Input.is_action_just_released("debug_1"):
			GameData.money += 1000
			AudioPlayer.play_ui_money_sound()
			print("Money: ", GameData.money)

		if Input.is_key_pressed(KEY_F12):
			Engine.set_time_scale(20)
		else:
			Engine.set_time_scale(1)

	match state:
		LevelStates.TITLE:
			pass

		LevelStates.MOVING:
			ship.movement_mult = 1.0

		LevelStates.CHECKPOINT:
			ship.movement_mult = 0.0

		LevelStates.GAME_OVER:
			ship.movement_mult = 0.0

func on_wave_over(wave, index):
	wave_index = index + 1

	#if wave_index > waves.waves.size() - 1:
	#	print("End of the game reached!")
	#	Overlay.show_modal(preload("res://game/main_menu/GameOverUI.tscn"))
	#	return

	if wave.is_checkpoint:
		AudioPlayer.play_music(preload("res://assets/audio/victory.ogg"), false)
		state = LevelStates.CHECKPOINT
		deliever_cargo()
		checkpoint_ui = get_node("%CheckpointUI").create_instance()
		checkpoint_ui.connect("tree_exited", on_checkpoint_continue_pressed)

func is_at_checkpoint()->bool:
	return state == LevelStates.CHECKPOINT

func deliever_cargo():
	last_checkpoint_cargo_worth = cargo_worth()
	if get_tree():
		for node in get_tree().get_nodes_in_group("ShipParts"):
			if ship.is_ancestor_of(node) and node is Cargo:
				node.get_parent().clear()
	GameData.money += last_checkpoint_cargo_worth

func calc_difficulty_multiplier():
	var difficulty_multiplier = 1.0
	if get_tree():
		for node in get_tree().get_nodes_in_group("ShipParts"):
			if ship.is_ancestor_of(node) and node is Cargo:
				difficulty_multiplier += node.attract_danger
	return difficulty_multiplier

func calc_difficulty():
	return checkpoint_index + (10 + checkpoint_index) * (calc_difficulty_multiplier()-1.0)

func cargo_worth():
	var value = 0.0
	if get_tree():
		for node in get_tree().get_nodes_in_group("ShipParts"):
			if ship.is_ancestor_of(node) and node is Cargo:
				value += node.delievery_value
	return value

func on_checkpoint_continue_pressed():
	if not is_inside_tree():
		return

	AudioPlayer.play_sound(preload("res://assets/audio/voice_defend_the_cargo_captain.wav"))
	await get_tree().create_timer(2).timeout

	AudioPlayer.play_music(preload("res://assets/audio/ludum1_3.ogg"))

	checkpoint_index += 1

	state = LevelStates.MOVING
	wave_index = 0
	waves = $WaveDirector.generate_waves(calc_difficulty())

	print("BEFORE")
	await get_tree().create_timer(CHECKPOINT_WAVE_DELAY).timeout
	print("AFTER")
	%MobSpawner.start_wave(waves.waves, wave_index)

func on_cargo_destroyed(_cargo: Cargo):
	var all_cargo_destroyed := is_all_cargo_destroyed()
	print("all_cargo_destroyed: ", all_cargo_destroyed)

	if state != LevelStates.GAME_OVER && all_cargo_destroyed:
		state = LevelStates.GAME_OVER

		var center = ship.position

		for i in range(10):
			var count := i * 2 - 2
			var position : Vector2
			for y in range(max(1, count)):
				position = Vector2(
					randi_range(center.x - 60, center.x + 60),
					randi_range(center.y - 60, center.y + 60)
				)
				FxSpawner.spawn_fx(preload("res://game/fx/explosion_1.tscn"), position)
				await get_tree().create_timer(0.02).timeout
			if i < 8:
				AudioPlayer.play_sound_random([
					preload("res://assets/audio/player_explode02.wav"),
					preload("res://assets/audio/explosion01.wav"),
				])
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
