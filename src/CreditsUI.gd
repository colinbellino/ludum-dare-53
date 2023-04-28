class_name CreditsUI extends CanvasLayer

var team_label: RichTextLabel
var button_close: Button
var button_quit: Button

signal closed

func _ready() -> void:
	team_label = get_node("%Team")
	button_close = get_node("%Close")
	button_quit = get_node("%Quit")

	button_close.connect("pressed", button_close_pressed)
	button_close.connect("pressed", play_button_sound)
	button_quit.connect("pressed", button_quit_pressed)
	button_quit.connect("pressed", play_button_sound)
	team_label.connect("meta_clicked", team_label_meta_clicked)
	team_label.text = Globals.load_file("res://credits.txt", "")

	close()

func open(show_quit_button: bool = false) -> void:
	button_quit.visible = false
	if show_quit_button:
		button_quit.visible = true

	visible = true

func close() -> void:
	visible = false
	closed.emit()

func button_close_pressed() -> void:
	Save.write_settings(Globals.settings)
	close()

func button_quit_pressed() -> void:
	Save.write_settings(Globals.settings)
	Game.quit_game()

func team_label_meta_clicked(uri) -> void:
	OS.shell_open(uri)

func play_button_sound(_whatever = null) -> void:
	# Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])
	pass
