class_name EmptySlotUI extends Node2D

var button_close : Button
var button_cargo : SlotActionButton
var button_danger_cargo : SlotActionButton

signal action_pressed(action, meta)

func _ready() -> void:
	button_close = get_node("%Close")
	button_close.connect("pressed", close_menu)
	button_cargo = get_node("Cargo")
	button_danger_cargo = get_node("DangerCargo")

func close_menu() -> void:
	queue_free()

func on_focus_changed(new_focus) -> void:
	if not is_ancestor_of(new_focus):
		queue_free()

func emit_action(child) -> void:
	emit_signal("action_pressed", child.action, child.meta)
	queue_free()

func open(_slot: ShipSlot) -> void:
	for child in get_children():
		if child is Button:
			continue
		child.pressed.connect(self.emit_action.bind(child))

	if GameData.level:
		button_cargo.visible = GameData.level.is_at_checkpoint
		button_danger_cargo.visible = GameData.level.is_at_checkpoint
	else:
		button_cargo.visible = false
		button_danger_cargo.visible = false

	get_viewport().connect("gui_focus_changed", self.on_focus_changed)
