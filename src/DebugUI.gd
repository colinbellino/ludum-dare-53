class_name DebugUI extends CanvasLayer

var dump_label: Label
var version_label: Label

func _ready() -> void:
	dump_label = get_node("%Dump")
	version_label = get_node("%Version")
