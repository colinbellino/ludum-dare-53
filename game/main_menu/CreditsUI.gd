extends CanvasLayer

var label_team : Label

func _ready():
	label_team = get_node("%Team")
	label_team.text = Utils.load_file("res://credits.txt", "")

func close():
	queue_free()

func open_link(meta):
	OS.shell_open(meta)
