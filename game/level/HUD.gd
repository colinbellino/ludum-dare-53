class_name HUD extends Node

var pause_button: Button
var currency_label: Label
var health_label: Label
var control_health: Control
var level_panel: Control
var level_progress: ProgressBar
var level_from: Label
var level_to: Label
var debug_panel: Panel
var debug_label: Label

func _ready() -> void:
	pause_button = get_node("%Pause")
	pause_button.connect("pressed", pause_pressed_button)
	debug_panel = get_node("%DebugPanel")
	debug_panel.visible = OS.is_debug_build()
	debug_label = get_node("%DebugLabel")
	currency_label = get_node("%Currency")
	health_label = get_node("%HealthLabel")
	control_health = get_node("%HealthBar")
	level_progress = get_node("%Wave")
	level_panel = get_node("%Level")
	level_from = get_node("%From")
	level_from.text = ""
	level_to = get_node("%To")
	level_to.text = ""

# TODO: don't do this every frame
func _process(_delta: float) -> void:
	currency_label.text = tr("Currency: %d") % [GameData.money]
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

	health_label.text = "HP: %s/%s" % [GameData.level.ship.health_current, GameData.level.ship.health_max]
	var remaining = GameData.level.ship.health_current
	var children := control_health.get_children()
	for i in range(0, children.size()):
		var child := children[i]

		var value := clampi(remaining, 0, 4)
		child.set_value(value)
		remaining -= 4


func pause_pressed_button() -> void:
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
	debug_label.text = text
