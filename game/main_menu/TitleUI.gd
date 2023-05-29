extends CanvasLayer

var button_start :  Button

signal start_game_pressed()

func _ready() -> void:
	button_start = get_node("%Start")
	button_start.grab_focus()

	Settings.load_all()
	AudioPlayer.play_music(Res.MUSIC_TITLE)

	GameData.money = GameData.STARTING_MONEY

	Engine.set_time_scale(1)

	var version = Utils.load_file(Res.PATH_VERSION)
	print("version: ", version.strip_edges())

func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_cancel"):
		quit()

func start_game() -> void:
	if GameData.voice_played == false:
		AudioPlayer.play_sound(Res.SFX_WELCOME)
		GameData.voice_played = true

	await get_tree().create_timer(0.1).timeout
	Overlay.transition(Res.SCENE_WORLD_MAP)

func settings() -> void:
	Overlay.show_modal(Res.SCENE_SETTINGS, false)

func credits() -> void:
	Overlay.show_modal(Res.SCENE_CREDITS, false)

func quit() -> void:
	get_tree().quit()
