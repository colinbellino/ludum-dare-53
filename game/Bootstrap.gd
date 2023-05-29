class_name Bootstrap extends Node

const PARALLAX_SPEED : int = 30

func _ready() -> void:
	Game.hud.visible = false

	Engine.set_time_scale(1)
	var version = Utils.load_file(Res.PATH_VERSION)
	print("version: ", version.strip_edges())
	GameData.money = GameData.STARTING_MONEY

	var title_node = Overlay.show_modal(Res.SCENE_TITLE, false)
	title_node.connect("start_game_pressed", start_game)

func _process(delta: float) -> void:
	Game.parallax_bg.scroll_base_offset += Game.parallax_bg.scroll_base_scale * delta * Game.ship.movement_mult * PARALLAX_SPEED

	if OS.is_debug_build():
		if Input.is_action_just_released("debug_1"):
			GameData.money += 1000
			AudioPlayer.play_ui_money_sound()

		if Input.is_action_just_released("debug_11"):
			GameData.cheat_skip_checkpoint = !GameData.cheat_skip_checkpoint

		if Input.is_action_just_released("debug_12"):
			GameData.cheat_invincible = !GameData.cheat_invincible

		if Input.is_key_pressed(KEY_SHIFT):
			Engine.set_time_scale(20)
		else:
			Engine.set_time_scale(1)

func start_game() -> void:
	if GameData.voice_played == false:
		AudioPlayer.play_sound(Res.SFX_WELCOME)
		GameData.voice_played = true

	Overlay.show_modal(Res.SCENE_LEVEL, false)
