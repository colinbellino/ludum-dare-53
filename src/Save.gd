class_name Save

const settings_path : String = "user://settings.tres"

static func read_settings() -> GameSettings:
	var settings : GameSettings
	if ResourceLoader.exists(settings_path):
		settings = ResourceLoader.load(settings_path) as GameSettings
		print("[Save] Settings read from file.")
	else:
		print("[Save] Settings couldn't be read from file, creating default.")
		settings = GameSettings.new()
		var locales := TranslationServer.get_loaded_locales()
		var locale := OS.get_locale()
		var locale_0 := locale.split("_")[0]
		if locales.find(locale_0) > -1 && locale_0 != settings.locale:
			print("[Game] Detected locale %s" % [locale_0])
			Globals.settings.locale = locale_0
		write_settings(settings)
	return settings

static func write_settings(data: GameSettings) -> void:
	var result = ResourceSaver.save(data, settings_path)
	if result == OK:
		print("[Save] Settings written to file.")
	else:
		print("[Save] Settings couldn't be written to file: ", result)
