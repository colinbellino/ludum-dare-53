class_name Game extends Node

var initialized : bool

enum GameStates { INIT, TITLE, INTRO, PLAY }

func _ready() -> void:
	if Globals.initialized == false:
		return

	init()

func init():
	DisplayServer.window_set_title("LD53")

	Globals.set_cursor(Globals.CURSORS.DEFAULT)
	Globals.ui_play.visible = false

	# Connect the UI
	# Globals.ui_title.button_start.connect("pressed", self, "button_start_pressed")
	# Globals.ui_title.button_continue.connect("pressed", self, "button_continue_pressed")
	# Globals.ui_title.button_settings.connect("pressed", self, "button_settings_pressed")
	# Globals.ui_title.button_quit.connect("pressed", self, "button_quit_pressed")
	Globals.ui_debug.version_label.text = Globals.version

	Globals.ui_splash.visible = true
	await get_tree().process_frame
	Globals.ui_splash.visible = false

	change_state(GameStates.TITLE)

	initialized = true

func _process(delta: float):
	if initialized == false:
		return

	Globals.mouse_position = Globals.camera.get_local_mouse_position() / Globals.SPRITE_SIZE / Globals.SCALE
	Globals.mouse_closest_point = Globals.astar.get_closest_point(Globals.mouse_position - Globals.CELL_CENTER_OFFSET)
	Globals.time_elapsed += delta * 1000

	if Input.is_action_just_released("debug_1"):
		Globals.settings.debug_draw = !Globals.settings.debug_draw

	if Globals.game_state == GameStates.TITLE:
		if Globals.game_state_entered == false:
			Globals.game_state_entered = true

			Globals.ui_title.open()
			# Start playing menu music
			# Audio.play_music(Globals.MUSIC.MENU)

		if Input.is_action_just_released("ui_cancel"):
			quit_game()
			return

	if Globals.game_state == GameStates.INTRO:
		if Globals.game_state_entered == false:
			Globals.game_state_entered = true

			# TODO: load level

			if Globals.settings.debug_skip_title:
				Globals.ui_play.open()
				# Globals.ui_intro.visible = false

				start_game()
				return

			# TODO: play intro

			# Globals.ui_intro.visible = false

			Engine.time_scale = 1

			await get_tree().process_frame

			start_game()

	if Globals.game_state == GameStates.PLAY:
		if Globals.game_state_entered == false:
			Globals.game_state_entered = true

		if OS.is_debug_build() && Input.is_action_just_released("debug_2"):
			Globals.ending(0)
			return

		if Globals.ui_settings.visible:
			Engine.time_scale = 0

			if Input.is_action_just_released("ui_cancel"):
				Globals.ui_settings.close()

		else:
			if Input.is_key_pressed(KEY_SHIFT):
				Engine.time_scale = 10
			else:
				Engine.time_scale = 1

			if Input.is_action_just_released("ui_cancel"):
				Globals.ui_settings.open(true)
				# Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])

			Globals.ui_debug.dump_label.text = JSON.stringify({
				"time_scale": "x%s" % [Engine.time_scale],
				"time_elapsed": Globals.time_elapsed,
				"delta": delta,
			}, "  ")

static func button_start_pressed() -> void:
	# start_game()
	pass

static func button_continue_pressed() -> void:
	# Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])
	Globals.ui_title.close()

static func button_settings_pressed() -> void:
	# Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])
	Globals.ui_settings.open()

static func button_quit_pressed() -> void:
	quit_game()

static func start_game() -> void:
	Globals.ui_title.close()
	Globals.ui_play.open()
	# Audio.play_music(Globals.MUSIC.CALM)

	change_state(GameStates.PLAY)

static func change_state(state) -> void:
	print("[Game] Changing state: %s" % [GameStates.keys()[state]])
	Globals.game_state = state
	Globals.game_state_entered = false

static func quit_game() -> void:
	print("[Game] Quitting...")
	Save.write_settings(Globals.settings)
	Globals.get_tree().quit()
