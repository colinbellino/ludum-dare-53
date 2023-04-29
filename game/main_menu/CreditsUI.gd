extends CanvasLayer

func _ready():
	%Team.text = Utils.load_file("res://credits.txt", "")

func close():
	queue_free()

func open_link(meta):
	OS.shell_open(meta)
