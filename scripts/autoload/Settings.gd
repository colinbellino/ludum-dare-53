extends Node

var resource : SettingsResource

func can_change_resolution() -> bool:
	return OS.get_name() != "Web"

func can_fullscreen() -> bool:
	return OS.has_feature("pc")

func save_all() -> void:
	Utils.write_settings(resource);

func load_all() -> void:
	resource = Utils.read_settings()
	# print("- window_fullscreen: ", resource.window_fullscreen)
	# print("- resolution: ", resource.resolution)
	# print("- volume_main: ", resource.volume_main)
	# print("- volume_music: ", resource.volume_music)
	# print("- volume_sound: ", resource.volume_sound)
	# print("- locale: ", resource.locale)
	# print("- level: ", resource.level)

	if can_fullscreen():
		Utils.set_fullscreen(resource.window_fullscreen)
	Utils.set_resolution(resource.resolution)
	Utils.set_linear_db(AudioPlayer.bus_main, resource.volume_main)
	Utils.set_linear_db(AudioPlayer.bus_music, resource.volume_music)
	Utils.set_linear_db(AudioPlayer.bus_sound, resource.volume_sound)
	TranslationServer.set_locale(resource.locale)
