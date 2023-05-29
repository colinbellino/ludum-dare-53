class_name PauseUI extends CanvasLayer

var button_close: Button
var button_settings: Button
var button_title: Button
var button_quit: Button
var child_node: Node

signal closed

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	button_close = get_node("%Close")
	button_close.connect("pressed", button_close_pressed)
	button_settings = get_node("%Settings")
	button_settings.connect("pressed", button_settings_pressed)
	button_title = get_node("%Title")
	button_title.connect("pressed", button_title_pressed)
	button_quit = get_node("%Quit")
	button_quit.connect("pressed", button_quit_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_cancel"):
		if child_node == null:
			close()

func close() -> void:
	closed.emit()
	queue_free()

func button_close_pressed() -> void:
	close()

func button_settings_pressed() -> void:
	child_node = Overlay.show_modal(Res.SCENE_SETTINGS)

func button_title_pressed() -> void:
	queue_free()
	Overlay.transition(Res.SCENE_TITLE)

func button_quit_pressed() -> void:
	get_tree().quit()
