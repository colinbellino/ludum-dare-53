extends CanvasLayer

func _ready():
	%Start.grab_focus()

func start_game():
	# TODO
	# Overlay.transition("res://game/level1/Level1.tscn")
	pass

func settings():
	Overlay.show_modal(preload("res://game/main_menu/SettingsUI.tscn"))

func credits():
	Overlay.show_modal(preload("res://game/main_menu/CreditsUI.tscn"))

func quit() -> void:
	get_tree().quit()
