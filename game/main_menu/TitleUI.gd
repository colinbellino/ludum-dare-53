extends CanvasLayer

func _ready():
	%Start.grab_focus()

func _process(_delta: float):
	if Input.is_action_just_released("ui_cancel"):
		quit()

func start_game():
	Overlay.transition("res://game/level/Level.tscn")

func settings():
	Overlay.show_modal(preload("res://game/main_menu/SettingsUI.tscn"))

func credits():
	Overlay.show_modal(preload("res://game/main_menu/CreditsUI.tscn"))

func quit() -> void:
	get_tree().quit()
