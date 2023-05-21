class_name PauseUI extends CanvasLayer

var button_close: Button
var button_settings: Button
var button_title: Button
var button_quit: Button

signal closed

func _ready() -> void:
	button_close = get_node("%Close")
	button_close.connect("pressed", button_close_pressed)
	button_settings = get_node("%Settings")
	button_settings.connect("pressed", button_settings_pressed)
	button_title = get_node("%Title")
	button_title.connect("pressed", button_title_pressed)
	button_quit = get_node("%Quit")
	button_quit.connect("pressed", button_quit_pressed)

func button_close_pressed() -> void:
	closed.emit()
	queue_free()

func button_settings_pressed() -> void:
	Overlay.show_modal(preload("res://game/main_menu/SettingsUI.tscn"), false)

func button_title_pressed() -> void:
	print("button_title_pressed")

func button_quit_pressed() -> void:
	get_tree().quit()
