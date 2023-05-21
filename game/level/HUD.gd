class_name HUD extends Control

var button_pause: Button
var panel_debug: Panel
var label_money: Label
var label_wave: Label

func _ready() -> void:
	button_pause = get_node("%Pause")
	button_pause.connect("pressed", button_pause_pressed)
	panel_debug = get_node("%DebugPanel")
	panel_debug.visible = OS.is_debug_build()
	label_money = get_node("%Money")
	label_wave = get_node("%Wave")

func _process(_delta: float) -> void:
	if GameData.level:
		label_money.text = tr("Currency: %d") % [GameData.money]
		label_wave.text = "Wave: %s" % [GameData.level.wave_index]

func button_pause_pressed() -> void:
	Overlay.show_modal(preload("res://game/main_menu/PauseUI.tscn"))
