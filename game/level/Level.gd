class_name Level extends Node

@export var waves : WaveList

var checkpoint_ui : CheckpointUI
var checkpoint_index : int = 1
var next_wave_index : int
var last_checkpoint_cargo_worth : int
var mob_spawner : MobSpawner
var wave_director : WaveDirector
var is_at_checkpoint : bool
var game_over_triggered : bool

const CHECKPOINT_WAVE_DELAY : int = 5

signal checkpoint_reached()
signal checkpoint_departed()

func _ready() -> void:
	wave_director = get_node("%WaveDirector")
	mob_spawner = get_node("%MobSpawner")
	mob_spawner.connect("wave_over", on_wave_over)
	mob_spawner.connect("wave_spawn", on_wave_spawn)
	next_wave_index = 0
	Game.hud.visible = true

	Engine.set_time_scale(1)
	Game.level = self
	GameData.money = GameData.STARTING_MONEY

	mob_spawner.start_wave(waves.waves, next_wave_index)

func _exit_tree() -> void:
	Game.level = null
	Game.hud.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_cancel"):
		Overlay.show_modal(Res.SCENE_PAUSE)

	Game.ship.movement_mult = 1.0
	GameData.money += delta * 5.0

func on_wave_spawn(wave: Wave, _wave_index: int, _wave_length: int) -> void:
	if wave.is_checkpoint:
		is_at_checkpoint = true

func on_wave_over(_wave: Wave, wave_index: int, _wave_length: int) -> void:
	next_wave_index = wave_index + 1

func trigger_checkpoint_reached() -> void:
	emit_signal("checkpoint_reached")

	AudioPlayer.play_music(Res.MUSIC_VICTORY, false)
	if GameData.cheat_skip_checkpoint:
		on_checkpoint_continue_pressed()
		return

	deliver_cargo()
	checkpoint_ui = Game.checkpoint_ui.create_instance()
	checkpoint_ui.connect("tree_exited", on_checkpoint_continue_pressed)

	is_at_checkpoint = true

	await get_tree().create_timer(2.3).timeout
	AudioPlayer.play_music(Res.MUSIC_INTERMISSION)

func deliver_cargo() -> void:
	last_checkpoint_cargo_worth = cargo_worth()
	if get_tree():
		for node in get_tree().get_nodes_in_group("ShipParts"):
			if Game.ship.is_ancestor_of(node) and node is Cargo:
				node.get_parent().clear()
	GameData.money += last_checkpoint_cargo_worth

func calc_difficulty_multiplier() -> float:
	var difficulty_multiplier = 1.0
	if get_tree():
		for node in get_tree().get_nodes_in_group("ShipParts"):
			if Game.ship.is_ancestor_of(node) and node is Cargo:
				difficulty_multiplier += node.attract_danger
	return difficulty_multiplier

func calc_difficulty() -> float:
	return checkpoint_index + (4 + checkpoint_index) * (calc_difficulty_multiplier()-1.0)

func cargo_worth() -> int:
	var value = 0
	if get_tree():
		for node in get_tree().get_nodes_in_group("ShipParts"):
			if Game.ship.is_ancestor_of(node) and node is Cargo:
				value += node.delievery_value
	return value

func on_checkpoint_continue_pressed() -> void:
	if not is_inside_tree():
		return

	emit_signal("checkpoint_departed")

	AudioPlayer.play_sound(Res.SFX_DEFEND_CARGO)
	await get_tree().create_timer(2).timeout

	AudioPlayer.play_music(Res.MUSIC_ENCOUNTER)

	checkpoint_index += 1

	# FIXME:
	# state = LevelStates.MOVING
	next_wave_index = 0
	waves = wave_director.generate_waves(calc_difficulty(), 60.0)

	await get_tree().create_timer(CHECKPOINT_WAVE_DELAY).timeout
	mob_spawner.start_wave(waves.waves, next_wave_index)

func on_cargo_destroyed(_cargo: Cargo) -> void:
	if game_over_triggered == false && is_all_cargo_destroyed():
		print("Game over")
		game_over_triggered = true
		var ship_center = Game.ship.position

		for i in range(10):
			var count := i * 2 - 2
			var position : Vector2
			for y in range(max(1, count)):
				position = Vector2(
					randi_range(ship_center.x - 60, ship_center.x + 60),
					randi_range(ship_center.y - 60, ship_center.y + 60)
				)
				VFXPlayer.spawn_fx(Res.VFX_SHIP_EXPLOSION, position)
				await get_tree().create_timer(0.02).timeout
			if i < 8:
				AudioPlayer.play_sound_random([
					Res.SFX_EXPLOSION_0,
					Res.SFX_EXPLOSION_1,
				], position)
			await get_tree().create_timer(0.2).timeout

		var game_over = Overlay.show_modal(Res.SCENE_GAME_OVER)
		game_over.connect("close_pressed", on_game_over_closed)

func on_game_over_closed() -> void:
	queue_free()
	Overlay.transition(Res.SCENE_BOOTSTRAP)

func is_all_cargo_destroyed() -> bool:
	var cargo := 0
	var cargo_destroyed := 0
	for node in Game.ship.get_tree().get_nodes_in_group("Selectable"):
		if Game.ship.is_ancestor_of(node) and node is ShipSlot:
			if node.current_structure_node && node.current_structure_node is Cargo:
				cargo += 1
				if node.current_structure_node.hitpoints <= 0:
					cargo_destroyed += 1

	return cargo > 0 && cargo == cargo_destroyed
