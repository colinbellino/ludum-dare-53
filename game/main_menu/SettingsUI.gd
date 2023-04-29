class_name SettingsUI extends CanvasLayer

const RESOLUTIONS : Array = [
	["960  x 540", Vector2(960, 540)],
	["1280 x 720", Vector2(1280, 720)],
	["1920 x 1080", Vector2(1920, 1080)],
	["2560 x 1440", Vector2(2560, 1440)],
	["3840 x 2160", Vector2(3840, 2160)],
]

var button_fullscreen: CheckButton
var button_resolution: OptionButton
var button_locale: OptionButton
var button_close: Button
# var button_quit: Button
var slider_volume_main : Slider
var slider_volume_music : Slider
var slider_volume_sound : Slider

signal closed

func _ready() -> void:
	button_fullscreen = get_node("%Fullscreen")
	button_resolution = get_node("%Resolution")
	button_locale = get_node("%Locale")
	button_close = get_node("%Close")
	# button_quit = get_node("%Quit")
	slider_volume_main = get_node("%VolumeMain")
	slider_volume_music = get_node("%VolumeMusic")
	slider_volume_sound = get_node("%VolumeSound")

	button_fullscreen.connect("pressed", button_fullscreen_pressed)
	button_fullscreen.connect("pressed", play_button_sound)
	button_resolution.connect("item_selected", button_resolution_item_selected)
	button_resolution.connect("item_selected", play_button_sound)
	button_locale.connect("item_selected", button_locale_item_selected)
	button_locale.connect("item_selected", play_button_sound)
	button_close.connect("pressed", button_close_pressed)
	button_close.connect("pressed", play_button_sound)
	# button_quit.connect("pressed", button_quit_pressed)
	# button_quit.connect("pressed", play_button_sound)
	slider_volume_main.connect("value_changed", slider_volume_main_changed)
	slider_volume_main.connect("value_changed", play_button_sound)
	slider_volume_music.connect("value_changed", slider_volume_music_changed)
	slider_volume_music.connect("value_changed", play_button_sound)
	slider_volume_sound.connect("value_changed", slider_volume_sound_changed)
	slider_volume_sound.connect("value_changed", play_button_sound)

	if Settings.can_fullscreen():
		button_fullscreen.grab_focus()
		button_fullscreen.visible = true
		button_fullscreen.button_pressed = Settings.resource.window_fullscreen
	else:
		button_fullscreen.visible = false
		button_resolution.grab_focus()

	button_resolution.visible = false
	if Settings.can_change_resolution():
		button_resolution.visible = true
		button_resolution.clear()
		for index in range(RESOLUTIONS.size()):
			var item = RESOLUTIONS[index]
			button_resolution.add_item(item[0])
			if Settings.resource.resolution == item[1]:
				button_resolution.selected = index

	slider_volume_main.value = Settings.resource.volume_main
	slider_volume_music.value = Settings.resource.volume_music
	slider_volume_sound.value = Settings.resource.volume_sound

	var locales := TranslationServer.get_loaded_locales()
	button_locale.clear()
	for locale in locales:
		button_locale.add_item("locale_" + locale)
	button_locale.selected = locales.find(Settings.resource.locale)

	# button_quit.visible = false
	# if show_quit_button:
	# 	button_quit.visible = true

func close() -> void:
	closed.emit()
	Settings.save_all()
	queue_free()

func button_fullscreen_pressed() -> void:
	Settings.resource.window_fullscreen = !Settings.resource.window_fullscreen
	Utils.set_fullscreen(Settings.resource.window_fullscreen)

func button_resolution_item_selected(resolution_index: int) -> void:
	Settings.resource.resolution = RESOLUTIONS[resolution_index][1]
	Utils.set_resolution(Settings.resource.resolution)

func button_locale_item_selected(locale_index: int) -> void:
	var locales := TranslationServer.get_loaded_locales()
	Settings.resource.locale = locales[locale_index]
	TranslationServer.set_locale(Settings.resource.locale)

func button_close_pressed() -> void:
	Utils.write_settings(Settings.resource)
	close()

# func button_quit_pressed() -> void:
# 	Utils.write_settings(Settings.resource)
# 	# FIXME:
# 	# Game.quit_game()

func slider_volume_main_changed(value: float) -> void:
	Settings.resource.volume_main = value
	Utils.set_linear_db(AudioPlayer.bus_main, Settings.resource.volume_main)
	# print("Settings.resource.volume_main", Settings.resource.volume_main)

func slider_volume_music_changed(value: float) -> void:
	Settings.resource.volume_music = value
	Utils.set_linear_db(AudioPlayer.bus_music, Settings.resource.volume_music)
	# print("Settings.resource.volume_music", Settings.resource.volume_music)

func slider_volume_sound_changed(value: float) -> void:
	Settings.resource.volume_sound = value
	Utils.set_linear_db(AudioPlayer.bus_sound, Settings.resource.volume_sound)
	# print("Settings.resource.volume_sound", Settings.resource.volume_sound)

func play_button_sound(_whatever = null) -> void:
	AudioPlayer.play_ui_button_sound()
