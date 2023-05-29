extends CanvasLayer

var label_team : Label

func _ready() -> void:
	label_team = get_node("%Team")
	label_team.text = Utils.load_file(GameData.PATH_CREDITS)

func close() -> void:
	queue_free()

func open_link(meta: String) -> void:
	OS.shell_open(meta)
