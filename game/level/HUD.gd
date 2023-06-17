class_name HUD extends Node

var button_pause: Button
var label_currency: Label
var label_health: Label
var level_panel: Panel
var level_progress: ProgressBar
var level_from: Label
var level_to: Label
var panel_debug: Panel
var label_debug: Label

func _ready() -> void:
	button_pause = get_node("%Pause")
	button_pause.connect("pressed", button_pause_pressed)
	panel_debug = get_node("%DebugPanel")
	panel_debug.visible = OS.is_debug_build()
	label_debug = get_node("%DebugLabel")
	label_currency = get_node("%Currency")
	label_health = get_node("%HealthLabel")
	level_progress = get_node("%Wave")
	level_panel = get_node("%Level")
	level_from = get_node("%From")
	level_from.text = ""
	level_to = get_node("%To")
	level_to.text = ""

# TODO: don't do this every frame
func _process(_delta: float) -> void:
	label_currency.text = tr("Currency: %d") % [GameData.money]
	update_health()
	if OS.is_debug_build():
		update_debug_panel()

func show_level() -> void:
	level_panel.visible = true
	if GameData.map_previous_nodes.size() > 1:
		var from_node = GameData.map_previous_nodes[GameData.map_previous_nodes.size() - 2]
		var to_node = GameData.map_previous_nodes[GameData.map_previous_nodes.size() - 1]
		level_to.text = to_node.name
		level_from.text = from_node.name

func hide_level() -> void:
	level_panel.visible = false
	level_progress.value = 0.0

func update_health() -> void:
	if GameData.level == null:
		return

	label_health.text = "HP: %s/%s" % [GameData.level.ship.health_current, GameData.level.ship.health_max]

func button_pause_pressed() -> void:
	Overlay.show_modal(Res.SCENE_PAUSE)

func update_wave_progress(wave: Wave, wave_index: int, wave_length: int) -> void:
	var bg = level_progress.get("theme_override_styles/fill").duplicate()

	if wave.is_checkpoint:
		level_progress.value = 1.0
		bg.bg_color = GameData.COLOR_ORANGE
	else:
		level_progress.value = float(wave_index + 1) / wave_length
		bg.bg_color = GameData.COLOR_GREEN
	level_progress.set("theme_override_styles/fill", bg)

# TODO: move this to DevTools.gd
func update_debug_panel() -> void:
	var text = "Version: %s

- Shift : Speed up (x%s)
- F1    : Money +1000
- F10   : Kill all mobs
- F11   : Skip checkpoints (%s)
- F12   : Invincibility (%s)" % [GameData.version, Engine.time_scale, "ON" if GameData.cheat_skip_checkpoint else "OFF", "ON" if GameData.cheat_invincible else "OFF"]
	label_debug.text = text
