class_name Level extends Node

var waves_list : WaveList
var checkpoint_ui_placeholder : InstancePlaceholder
var checkpoint_index : int = 1
var next_wave_index : int
var last_checkpoint_cargo_worth : int
var mob_spawner : MobSpawner
var wave_director : WaveDirector
var is_at_checkpoint : bool
var game_over_triggered : bool
var ship : Ship
var hud : HUD
var movement_mult : float

signal checkpoint_reached()
signal checkpoint_departed()

func _ready() -> void:
	hud = get_node("%HUD")
	ship = get_node("%Ship")
	checkpoint_ui_placeholder = get_node("%CheckpointUI")
	wave_director = get_node("%WaveDirector")
	mob_spawner = get_node("%MobSpawner")
	mob_spawner.connect("wave_over", on_wave_over)
	mob_spawner.connect("wave_spawn", on_wave_spawn)
	next_wave_index = 0
	hud.visible = true

	Engine.set_time_scale(1)
	GameData.level = self
	GameData.money = GameData.STARTING_MONEY
	ship.health_current = ship.health_max

	hud.update_health()

	# start_wave()

	if GameData.open_worlmap_on_level_ready:
		GameData.open_worlmap_on_level_ready = false
		var world_map = Overlay.show_modal(Res.SCENE_WORLD_MAP)
		world_map.connect("tree_exited", start_wave)

func _exit_tree() -> void:
	GameData.level = null

func _process(delta: float) -> void:
	check_game_over()

	if Input.is_action_just_released("ui_cancel"):
		Overlay.show_modal(Res.SCENE_PAUSE)

	GameData.money += delta * 5.0

func on_wave_spawn(wave: Wave, _wave_index: int, _wave_length: int) -> void:
	if wave.is_checkpoint:
		is_at_checkpoint = true

func on_wave_over(wave: Wave, wave_index: int, wave_length: int) -> void:
	hud.update_wave_progress(wave, wave_index, wave_length)
	next_wave_index = wave_index + 1

func trigger_checkpoint_reached() -> void:
	hud.hide_level()
	emit_signal("checkpoint_reached")

	AudioPlayer.play_music(Res.MUSIC_VICTORY, false)
	if GameData.cheat_skip_checkpoint:
		on_checkpoint_continue_pressed()
		return

	deliver_cargo()
	var checkpoint_ui := checkpoint_ui_placeholder.create_instance()
	checkpoint_ui.connect("tree_exited", on_checkpoint_continue_pressed)

	is_at_checkpoint = true

	await get_tree().create_timer(2.3).timeout
	AudioPlayer.play_music(Res.MUSIC_INTERMISSION)

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
	emit_signal("checkpoint_departed")

	var world_map = Overlay.show_modal(Res.SCENE_WORLD_MAP)
	world_map.connect("tree_exited", start_wave)

func start_wave() -> void:
	hud.show_level()
	next_wave_index = 0
	waves_list = wave_director.generate_waves(calc_difficulty(), 60.0)
	mob_spawner.start_wave(waves_list.waves, next_wave_index)
	movement_mult = 1.0

	AudioPlayer.play_sound(Res.SFX_DEFEND_CARGO)
	await get_tree().create_timer(2).timeout

func check_game_over() -> void:
	if game_over_triggered == false && ship.health_current <= 0:
		print("Game over")
		movement_mult = 0.0
		game_over_triggered = true

		for i in range(10):
			var count := i * 2 - 2
			var position : Vector2
			for y in range(max(1, count)):
				position = Vector2(
					randi_range(-60, +60),
					randi_range(-60, +60)
				)
				VFXPlayer.spawn_fx(Res.VFX_SHIP_EXPLOSION, position, ship)
				await get_tree().create_timer(0.02).timeout
			if i < 8:
				AudioPlayer.play_sound_random([
					Res.SFX_EXPLOSION_0,
					Res.SFX_EXPLOSION_1,
				], position)
			await get_tree().create_timer(0.2).timeout

		Overlay.transition(Res.SCENE_GAME_OVER)

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
