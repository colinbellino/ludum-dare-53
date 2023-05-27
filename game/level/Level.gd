class_name Level extends Node

@export var waves : WaveList

var ship : Ship
var state : LevelStates
var chunks : Array[Node]
var checkpoint_ui : CheckpointUI
var checkpoint_index : int = 1
var next_wave_index : int
var last_checkpoint_cargo_worth : int
var cargo_required : int = 150
var mob_spawner : MobSpawner
var wave_director : WaveDirector
var hud : Control
var parallax_bg : ParallaxBackground

const CHECKPOINT_WAVE_DELAY : int = 5
const PARALLAX_SPEED : int = 30

signal checkpoint_reached()
signal checkpoint_departed()

enum LevelStates { TITLE, MOVING, ENTER_CHECKPOINT, CHECKPOINT, GAME_OVER }

func _ready() -> void:
	Engine.set_time_scale(1)

	wave_director = get_node("%WaveDirector")
	parallax_bg = get_node("%BG")

	AudioPlayer.play_music(preload("res://assets/audio/ludum_title.ogg"))

	next_wave_index = 0
	var version = Utils.load_file("res://version.txt")
	print("version: ", version.strip_edges())

	hud = get_node("%HUD")
	hud.visible = false

	GameData.level = self
	GameData.money = GameData.STARTING_MONEY

	ship = get_node("%Ship")
	mob_spawner = get_node("%MobSpawner")

	var title_node = Overlay.show_modal(preload("res://game/main_menu/TitleUI.tscn"), false)
	title_node.connect("tree_exited", start_game)

	mob_spawner.connect("wave_over", on_wave_over)
	mob_spawner.connect("wave_spawn", on_wave_spawn)

func _exit_tree() -> void:
	GameData.level = null

func _process(delta: float) -> void:
	parallax_bg.scroll_base_offset += parallax_bg.scroll_base_scale * delta * ship.movement_mult * PARALLAX_SPEED

	if Input.is_action_just_released("debug_1"):
		GameData.money += 1000
		AudioPlayer.play_ui_money_sound()

	if OS.is_debug_build():
		if Input.is_action_just_released("debug_12"):
			GameData.cheat_invincible = !GameData.cheat_invincible
		if Input.is_action_just_released("debug_11"):
			GameData.cheat_skip_checkpoint = !GameData.cheat_skip_checkpoint

		if Input.is_key_pressed(KEY_SHIFT):
			Engine.set_time_scale(20)
		else:
			Engine.set_time_scale(1)

	match state:
		LevelStates.TITLE:
			pass

		LevelStates.MOVING:
			if Input.is_action_just_released("ui_cancel"):
				Overlay.show_modal(preload("res://game/main_menu/PauseUI.tscn"))

			ship.movement_mult = 1.0
			GameData.money += delta * 5.0

		LevelStates.ENTER_CHECKPOINT:
			if Input.is_action_just_released("ui_cancel"):
				Overlay.show_modal(preload("res://game/main_menu/PauseUI.tscn"))

			ship.movement_mult = 1.0

		LevelStates.CHECKPOINT:
			if Input.is_action_just_released("ui_cancel"):
				Overlay.show_modal(preload("res://game/main_menu/PauseUI.tscn"))

			ship.movement_mult = 0.0

		LevelStates.GAME_OVER:
			ship.movement_mult = 0.0

func start_game() -> void:
	if GameData.voice_played == false:
		AudioPlayer.play_sound(preload("res://assets/audio/voice_welcome_to_space_haulers.wav"))
		GameData.voice_played = true

	hud.visible = true
	state = LevelStates.MOVING
	mob_spawner.start_wave(waves.waves, next_wave_index)

func on_wave_spawn(wave: Wave, _wave_index: int, _wave_length: int) -> void:
	if wave.is_checkpoint:
		state = LevelStates.ENTER_CHECKPOINT

func on_wave_over(_wave: Wave, wave_index: int, _wave_length: int) -> void:
	next_wave_index = wave_index + 1

func trigger_checkpoint_reached() -> void:
	emit_signal("checkpoint_reached")

	AudioPlayer.play_music(preload("res://assets/audio/victory.ogg"), false)
	state = LevelStates.CHECKPOINT
	if GameData.cheat_skip_checkpoint:
		on_checkpoint_continue_pressed()
		return

	deliver_cargo()
	checkpoint_ui = get_node("%CheckpointUI").create_instance()
	checkpoint_ui.connect("tree_exited", on_checkpoint_continue_pressed)

	await get_tree().create_timer(2.3).timeout
	AudioPlayer.play_music(preload("res://assets/audio/Ludum_intermission02.ogg"))

func is_at_checkpoint() -> bool:
	return state == LevelStates.CHECKPOINT

func deliver_cargo() -> void:
	last_checkpoint_cargo_worth = cargo_worth()
	if get_tree():
		for node in get_tree().get_nodes_in_group("ShipParts"):
			if ship.is_ancestor_of(node) and node is Cargo:
				node.get_parent().clear()
	GameData.money += last_checkpoint_cargo_worth

func calc_difficulty_multiplier() -> float:
	var difficulty_multiplier = 1.0
	if get_tree():
		for node in get_tree().get_nodes_in_group("ShipParts"):
			if ship.is_ancestor_of(node) and node is Cargo:
				difficulty_multiplier += node.attract_danger
	return difficulty_multiplier

func calc_difficulty() -> float:
	return checkpoint_index + (4 + checkpoint_index) * (calc_difficulty_multiplier()-1.0)

func cargo_worth() -> int:
	var value = 0
	if get_tree():
		for node in get_tree().get_nodes_in_group("ShipParts"):
			if ship.is_ancestor_of(node) and node is Cargo:
				value += node.delievery_value
	return value

func on_checkpoint_continue_pressed() -> void:
	if not is_inside_tree():
		return

	emit_signal("checkpoint_departed")

	AudioPlayer.play_sound(preload("res://assets/audio/voice_defend_the_cargo_captain.wav"))
	await get_tree().create_timer(2).timeout

	AudioPlayer.play_music(preload("res://assets/audio/ludum1_3.ogg"))

	checkpoint_index += 1

	state = LevelStates.MOVING
	next_wave_index = 0
	waves = wave_director.generate_waves(calc_difficulty(), 60.0)

	await get_tree().create_timer(CHECKPOINT_WAVE_DELAY).timeout
	mob_spawner.start_wave(waves.waves, next_wave_index)

func on_cargo_destroyed(_cargo: Cargo) -> void:
	var all_cargo_destroyed := is_all_cargo_destroyed()

	if state != LevelStates.GAME_OVER && all_cargo_destroyed:
		print("Game over")
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
				FxSpawner.spawn_fx(preload("res://game/fx/ShipExplosion.tscn"), position)
				await get_tree().create_timer(0.02).timeout
			if i < 8:
				AudioPlayer.play_sound_random([
					preload("res://assets/audio/player_explode02.wav"),
					preload("res://assets/audio/explosion01.wav"),
				], position)
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
