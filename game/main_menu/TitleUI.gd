extends CanvasLayer

func _ready():
	Settings.load_all()

	# TODO: we probably don't want to do this in here?
	AudioPlayer.play_music(preload("res://assets/audio/ludum1.ogg"))

	%Start.grab_focus()

func _process(_delta: float):
	if Input.is_action_just_released("ui_cancel"):
		quit()

func start_game():
	var level_name := "res://game/level/" + Settings.resource.level + ".tscn";
	# Safety check so we don't load an invalid level if we have an old settings format
	if ResourceLoader.exists(level_name) == false:
		level_name = "res://game/level/Level.tscn"
	Overlay.transition(level_name)

func settings():
	Overlay.show_modal(preload("res://game/main_menu/SettingsUI.tscn"), false)

func credits():
	Overlay.show_modal(preload("res://game/main_menu/CreditsUI.tscn"), false)

func quit() -> void:
	get_tree().quit()
