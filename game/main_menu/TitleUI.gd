extends CanvasLayer

func _ready():
	Settings.load_all()

	%Start.grab_focus()

func _process(_delta: float):
	if Input.is_action_just_released("ui_cancel"):
		quit()

func start_game():
	queue_free()

func settings():
	Overlay.show_modal(preload("res://game/main_menu/SettingsUI.tscn"), false)

func credits():
	Overlay.show_modal(preload("res://game/main_menu/CreditsUI.tscn"), false)

func quit() -> void:
	get_tree().quit()
