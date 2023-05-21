class_name HUD extends Control

var button_pause: Button

func _ready() -> void:
	button_pause = get_node("%Pause")
	button_pause.connect("pressed", button_pause_pressed)

func _process(_delta: float) -> void:
	if GameData.level:
		%Money.text = tr("Currency: %d") % [GameData.money]
		%Wave.text = "Wave: %s" % [GameData.level.wave_index]

func button_pause_pressed() -> void:
	Overlay.show_modal(preload("res://game/main_menu/PauseUI.tscn"))
