extends Node

# Constants
const UINT8_MAX  = (1 << 8)  - 1 # 255
const UINT16_MAX = (1 << 16) - 1 # 65535
const UINT32_MAX = (1 << 32) - 1 # 4294967295

const INT8_MIN  = -(1 << 7)  # -128
const INT16_MIN = -(1 << 15) # -32768
const INT32_MIN = -(1 << 31) # -2147483648
const INT64_MIN = -(1 << 63) # -9223372036854775808

const INT8_MAX  = (1 << 7)  - 1 # 127
const INT16_MAX = (1 << 15) - 1 # 32767
const INT32_MAX = (1 << 31) - 1 # 2147483647
const INT64_MAX = (1 << 63) - 1 # 9223372036854775807

const font1_path : String = "res://media/fonts/silver.ttf"
const resolutions : Array = [
	["1280 x 720", Vector2(1280, 720)],
	["1920 x 1080", Vector2(1920, 1080)],
	["2560 x 1440", Vector2(2560, 1440)],
	["3840 x 2160", Vector2(3840, 2160)],
]
const SPRITE_SIZE : int = 16
const SCALE : int = 4
const CELL_CENTER_OFFSET : Vector2 = Vector2(0.5, 0.5)
const LETTER_APPEAR_DELAY : float = 0.05

enum CURSORS { DEFAULT, HIGHLIGHT, HAND, HAND_HIGHLIGHT, PET, CLEAN }
const CURSOR_SCALE : int = 4

# Resources
@onready var cursor_textures : Array[Resource] = [
	# ResourceLoader.load("res://media/art/ui/cursor_0.png"),
	# ResourceLoader.load("res://media/art/ui/cursor_1.png"),
	# ResourceLoader.load("res://media/art/ui/cursor_2.png"),
	# ResourceLoader.load("res://media/art/ui/cursor_3.png"),
	# ResourceLoader.load("res://media/art/ui/cursor_4.png"),
	# ResourceLoader.load("res://media/art/ui/cursor_5.png"),
]

# State
var initialized : bool
var settings : GameSettings
var version : String = "0000000"
var can_fullscreen : bool
var can_change_resolution : bool
var is_touchscreen : bool
var bus_main : int
var bus_music : int
var bus_sound : int
var game_state : int
var game_state_entered : bool
var game_state_exited : bool
var astar : AStar2D
var creature_name : String
var mouse_position : Vector2
var mouse_closest_point : int = -1
var random = RandomNumberGenerator.new()
var time_elapsed : float
var restarting : bool

# Nodes
var ui_title : TitleUI
var ui_settings : SettingsUI
var ui_debug : DebugUI
var ui_credits : CreditsUI
var ui_play : PlayUI
var ui_splash : CanvasLayer
var world : Node2D
var current_level: Node2D
var current_level_data: Dictionary
var camera: Camera2D
var animation_player : AnimationPlayer
var screen_shake : ScreenShake
var audio_player_sound : AudioStreamPlayer2D
var audio_player_music : AudioStreamPlayer2D
var player : Sprite2D

func _ready() -> void:
	init()

func init() -> void:
	# Reset state (mainly for restarts)
	initialized = false
	game_state = 0
	game_state_entered = false
	game_state_exited = false
	mouse_position = Vector2.ZERO
	mouse_closest_point = -1
	time_elapsed = 0.0

	# Init stuff here
	Globals.settings = Save.read_settings()
	Globals.bus_main = AudioServer.get_bus_index("Master")
	assert(Globals.bus_main != null, "Globals.bus_main not initialized correctly.")
	Globals.bus_music = AudioServer.get_bus_index("Music")
	assert(Globals.bus_music != null, "Globals.bus_music not initialized correctly.")
	Globals.bus_sound = AudioServer.get_bus_index("Sound")
	assert(Globals.bus_sound != null, "Globals.bus_sound not initialized correctly.")
	Globals.world = null
	Globals.world = get_node("/root/Game/World")
	assert(Globals.world != null, "Globals.world not initialized correctly.")
	Globals.ui_title = null
	Globals.ui_title = get_node("/root/Game/TitleUI")
	assert(Globals.ui_title != null, "Globals.ui_title not initialized correctly.")
	Globals.ui_settings = null
	Globals.ui_settings = get_node("/root/Game/SettingsUI")
	assert(Globals.ui_settings != null, "Globals.ui_settings not initialized correctly.")
	Globals.ui_credits = null
	Globals.ui_credits = get_node("/root/Game/CreditsUI")
	assert(Globals.ui_credits != null, "Globals.ui_credits not initialized correctly.")
	Globals.ui_debug = null
	Globals.ui_debug = get_node("/root/Game/DebugUI")
	assert(Globals.ui_debug != null, "Globals.ui_debug not initialized correctly.")
	Globals.ui_splash = null
	Globals.ui_splash = get_node("/root/Game/SplashUI")
	assert(Globals.ui_splash != null, "Globals.ui_splash not initialized correctly.")
	Globals.ui_play = null
	Globals.ui_play = get_node("/root/Game/PlayUI")
	assert(Globals.ui_play != null, "Globals.ui_play not initialized correctly.")
	Globals.camera = null
	Globals.camera = get_node("/root/Game/MainCamera")
	assert(Globals.camera != null, "Globals.camera not initialized correctly.")
	Globals.animation_player = null
	Globals.animation_player = get_node("/root/Game/AnimationPlayer")
	assert(Globals.animation_player != null, "Globals.animation_player not initialized correctly.")
	Globals.audio_player_sound = null
	Globals.audio_player_sound = get_node("/root/Game/SoundPlayer")
	assert(Globals.audio_player_sound != null, "Globals.audio_player_sound not initialized correctly.")
	Globals.audio_player_music = null
	Globals.audio_player_music = get_node("/root/Game/MusicPlayer")
	assert(Globals.audio_player_music != null, "Globals.audio_player_music not initialized correctly.")
	Globals.screen_shake = null
	Globals.screen_shake = get_node("/root/Game/ScreenShake")
	assert(Globals.screen_shake != null, "Globals.screen_shake not initialized correctly.")
	Globals.version = load_file("res://version.txt", "1111111")
	assert(Globals.version != null, "Globals.version not initialized correctly.")
	Globals.can_fullscreen = OS.get_name() == "Windows"
	Globals.is_touchscreen = DisplayServer.is_touchscreen_available()
	Globals.can_change_resolution = OS.get_name() != "HTML5"
	Globals.random.randomize()
	Globals.astar = AStar2D.new()
	assert(Globals.astar != null, "Globals.astar not initialized correctly.")

	Globals.player = get_node("/root/Game/World/Player")
	assert(Globals.player != null, "Globals.player not initialized correctly.")

	if Globals.can_fullscreen:
		Globals.set_fullscreen(Globals.settings.window_fullscreen)
	Globals.set_resolution(Globals.settings.resolution)
	Globals.set_linear_db(Globals.bus_main, Globals.settings.volume_main)
	Globals.set_linear_db(Globals.bus_music, Globals.settings.volume_music)
	Globals.set_linear_db(Globals.bus_sound, Globals.settings.volume_sound)
	TranslationServer.set_locale(Globals.settings.locale)

	Globals.initialized = true

# Utils

func set_fullscreen(value: bool) -> void:
	if value == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func set_resolution(resolution: Vector2) -> void:
	if Globals.restarting:
		return

	DisplayServer.window_set_size(resolution)
	# get_viewport().set_size_override(true, resolution)
	# get_viewport().set_size_override_stretch(true)

func get_linear_db(bus_index: int) -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func set_linear_db(bus_index: int, linear_db: float) -> void:
	linear_db = clamp(linear_db, 0.0, 1.0)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_db))

static func load_file(filepath: String, default_value: String = "") -> String:
	var file := FileAccess.open(filepath, FileAccess.READ)
	if file == null:
		print("[Game] Couldn't load file: %s" % [filepath])
		return default_value

	var data = file.get_as_text()
	return data

static func load_game_names() -> Array:
	var text := load_file("res://game_names.txt", "LD53")
	var lines : Array = text.split("\n")
	if lines[lines.size() -1] == "":
		lines.pop_back()

	return lines

static func set_cursor(_cursor_id: int) -> void:
	push_warning("set_cursor not implemented")
	# var cursor_texture : Texture = Globals.cursor_textures[cursor_id]
	# var offset =  Vector2.ZERO
	# if [2, 3, 4].find(cursor_id) > -1:
	# 	offset = Vector2(3, 0) * CURSOR_SCALE
	# Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, offset)

static func ending(cause: int) -> void:
	Engine.time_scale = 0.0

	Globals.animation_player.play("Outro1")
	# yield(Globals.animation_player, "animation_finished")
	await Globals.animation_player.animation_finished
	Globals.ui_outro.open(cause)

static func restart_game() -> void:
	Globals.settings.debug_skip_title = true
	Save.write_settings(Globals.settings)

	var game = Globals.get_node("/root/Game")
	Globals.get_tree().root.remove_child(game)
	game.call_deferred("free")
	await Globals.get_tree().idle_frame

	Globals.initialized = false

	var new_game = ResourceLoader.load("res://media/scenes/main.tscn").instance()
	Globals.get_tree().root.add_child(new_game)
	await Globals.get_tree().idle_frame

	Globals.restarting = true
	Globals.init()
	Globals.restarting = false

	new_game.init()
