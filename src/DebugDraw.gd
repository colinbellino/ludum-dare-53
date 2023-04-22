class_name DebugDraw extends Control

var font : FontFile

func _ready() -> void:
	font = FontFile.new()
	font.font_data = ResourceLoader.load(Globals.font1_path)
	# font.size = 26

func _process(_delta: float) -> void:
	get_parent().visible = Globals.settings.debug_draw
	queue_redraw()

func _draw() -> void:
	if Globals.initialized == false:
		return

	if Globals.settings.debug_draw == false:
		return
