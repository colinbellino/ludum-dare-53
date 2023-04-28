class_name Utils

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
