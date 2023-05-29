extends CanvasLayer

var button_start :  Button

func _ready() -> void:
	button_start = get_node("%Start")
	button_start.grab_focus()
	Settings.load_all()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("ui_cancel"):
		quit()

func start_game() -> void:
	queue_free()

func settings() -> void:
	Overlay.show_modal(Res.UI_SETTINGS, false)

func credits() -> void:
	Overlay.show_modal(Res.UI_CREDITS, false)

func quit() -> void:
	get_tree().quit()
