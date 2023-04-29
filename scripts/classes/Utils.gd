class_name Utils

const settings_path : String = "user://settings.tres"

static func load_file(filepath: String, default_value: String = "") -> String:
	var file := FileAccess.open(filepath, FileAccess.READ)
	if file == null:
		print("[Game] Couldn't load file: %s" % [filepath])
		return default_value
	var data = file.get_as_text()
	return data

const UI_VALUE_PROPERTIES = ["value", "color", "selected_id", "selected", "pressed", "text", "bbcode"]

static func ui_set_value(ui_node:Control, new_value)->void:
	for prop in UI_VALUE_PROPERTIES:
		if prop in ui_node:
			return ui_node.set(prop, new_value)
	push_error("ui_node doesn't have a recognized value property.")

static func ui_get_value(ui_node:Control):
	for prop in UI_VALUE_PROPERTIES:
		if prop in ui_node:
			return ui_node.get(prop)
	push_error("ui_node doesn't have a recognized value property.")

static func sync_from_ui(mapping:Dictionary, target:Object):
	for node in mapping:
		target.set(mapping[node], ui_get_value(node))

static func sync_to_ui(mapping:Dictionary, source:Object):
	for node in mapping:
		ui_set_value(node, source.get(mapping[node]))

static func set_fullscreen(value: bool) -> void:
	if value == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

static func read_settings() -> SettingsResource:
	var settings : SettingsResource
	if ResourceLoader.exists(settings_path):
		settings = ResourceLoader.load(settings_path) as SettingsResource
		if settings:
			print("[Save] Settings read from file.")
		else:
			print("[Save] Error while reading settings.")
	if settings == null:
		print("[Save] Settings couldn't be read from file, creating default.")
		settings = SettingsResource.new()
		var locales := TranslationServer.get_loaded_locales()
		var locale := OS.get_locale()
		var locale_0 := locale.split("_")[0]
		if locales.find(locale_0) > -1 && locale_0 != settings.locale:
			print("[Game] Detected locale %s" % [locale_0])
			settings.locale = locale_0
		write_settings(settings)
	return settings

static func write_settings(data: SettingsResource) -> void:
	var result = ResourceSaver.save(data, settings_path)
	if result == OK:
		print("[Save] Settings written to file.")
	else:
		print("[Save] Settings couldn't be written to file: ", result)

static func get_linear_db(bus_index: int) -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(bus_index))

static func set_linear_db(bus_index: int, linear_db: float) -> void:
	linear_db = clamp(linear_db, 0.0, 1.0)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_db))

static func set_resolution(resolution: Vector2) -> void:
	DisplayServer.window_set_size(resolution)
