class_name ConstructedSlotUI extends Node2D

var button_close : Button

signal action_pressed(action, meta)

func _ready() -> void:
	button_close = get_node("%Close")
	button_close.connect("pressed", close_menu)

func close_menu() -> void:
	queue_free()

func on_focus_changed(new_focus) -> void:
	if not is_ancestor_of(new_focus):
		queue_free()

func emit_action(action: String, meta : PackedScene = null) -> void:
	emit_signal("action_pressed", action, meta)
	queue_free()

func open(slot: ShipSlot) -> void:
	for child in get_children():
		if child is Button:
			continue

		child.target = slot.current_structure_node
		child.pressed.connect(self.emit_action.bind(child.action, slot.current_structure))
		child.upd2(slot.current_structure)

	get_viewport().connect("gui_focus_changed", self.on_focus_changed)
