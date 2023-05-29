class_name HUD extends Control

var button_pause: Button
var panel_debug: Panel
var label_money: Label
var progress_wave: ProgressBar

func _ready() -> void:
	button_pause = get_node("%Pause")
	button_pause.connect("pressed", button_pause_pressed)
	panel_debug = get_node("%DebugPanel")
	panel_debug.visible = OS.is_debug_build()
	label_money = get_node("%Money")
	progress_wave = get_node("%Wave")

func _process(_delta: float) -> void:
	if GameData.level:
		if GameData.level.mob_spawner.is_connected("wave_over", on_wave_over) == false:
			GameData.level.mob_spawner.connect("wave_over", on_wave_over)

		label_money.text = tr("Currency: %d") % [GameData.money]

func button_pause_pressed() -> void:
	Overlay.show_modal(GameData.RESOUCE_UI_PAUSE)

func on_wave_over(wave: Wave, wave_index: int, wave_length: int) -> void:
	var bg = progress_wave.get("theme_override_styles/fill").duplicate()

	if wave.is_checkpoint:
		progress_wave.value = 1.0
		bg.bg_color = GameData.COLOR_ORANGE
	else:
		progress_wave.value = float(wave_index + 1) / wave_length
		bg.bg_color = GameData.COLOR_GREEN
	progress_wave.set("theme_override_styles/fill", bg)
