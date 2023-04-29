extends Node

var resource : SettingsResource

func can_change_resolution() -> bool:
	return OS.get_name() != "HTML5"

func can_fullscreen() -> bool:
	return OS.has_feature("pc")

func _ready():
	load_all()

	if can_fullscreen():
		Utils.set_fullscreen(resource.window_fullscreen)
	Utils.set_resolution(resource.resolution)
	Utils.set_linear_db(AudioPlayer.bus_main, resource.volume_main)
	Utils.set_linear_db(AudioPlayer.bus_music, resource.volume_music)
	Utils.set_linear_db(AudioPlayer.bus_sound, resource.volume_sound)
	TranslationServer.set_locale(resource.locale)

func save_all():
	Utils.write_settings(resource);
	pass

func load_all():
	resource = Utils.read_settings()
	print("- window_fullscreen: ", resource.window_fullscreen)
	print("- resolution: ", resource.resolution)
	print("- volume_main: ", resource.volume_main)
	print("- volume_music: ", resource.volume_music)
	print("- volume_sound: ", resource.volume_sound)
	print("- locale: ", resource.locale)
	print("- level: ", resource.level)
