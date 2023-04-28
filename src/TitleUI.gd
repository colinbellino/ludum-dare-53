class_name TitleUI extends CanvasLayer

var button_start: Button
var button_continue: Button
var button_settings: Button
var button_credits: Button
var button_quit: Button

func _ready() -> void:
	button_start = get_node("%Start")
	button_continue = get_node("%Continue")
	button_settings = get_node("%Settings")
	button_credits = get_node("%Credits")
	button_quit = get_node("%Quit")

	button_start.connect("mouse_entered", on_button_hover)
	button_start.connect("pressed", button_start_pressed)
	button_continue.connect("mouse_entered", on_button_hover)
	button_settings.connect("mouse_entered", on_button_hover)
	button_settings.connect("pressed", button_settings_pressed)
	button_credits.connect("mouse_entered", on_button_hover)
	button_credits.connect("pressed", button_credits_pressed)
	button_quit.connect("mouse_entered", on_button_hover)
	button_quit.connect("pressed", button_quit_pressed)
	Globals.ui_settings.connect("closed", button_settings_closed)

	close()

func open() -> void:
	button_start.grab_focus()
	visible = true

func close() -> void:
	visible = false

func on_button_hover():
	# Audio.play_sound_random([Globals.SFX.BUTTON_HOVER])
	pass

func _name_changed(new_text: String) -> void:
	if new_text.length() == 0:
		button_start.disabled = true
	else:
		button_start.disabled = false
		Globals.creature_name = new_text

func button_start_pressed() -> void:
	Game.start_game()

func button_settings_pressed() -> void:
	Globals.ui_settings.open()

func button_credits_pressed() -> void:
	Globals.ui_credits.open()

func button_settings_closed() -> void:
	print("button_settings_pressed")
	button_settings.grab_focus()

func button_quit_pressed() -> void:
	Game.quit_game()
