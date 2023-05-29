extends CanvasLayer

var button_start :  Button

signal start_game_pressed()

func _ready() -> void:
	button_start = get_node("%Start")
	button_start.grab_focus()

	Settings.load_all()
	AudioPlayer.play_music(Res.MUSIC_TITLE)

func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_cancel"):
		quit()

func start_game() -> void:
	emit_signal("start_game_pressed")
	queue_free()

func settings() -> void:
	Overlay.show_modal(Res.SCENE_SETTINGS, false)

func credits() -> void:
	Overlay.show_modal(Res.SCENE_CREDITS, false)

func quit() -> void:
	get_tree().quit()
