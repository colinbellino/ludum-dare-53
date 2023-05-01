extends Node2D

signal action_pressed(action, meta)

func on_focus_changed(new_focus):
	if not is_ancestor_of(new_focus):
		queue_free()

func emit_action(action:String, meta = null):
	emit_signal("action_pressed", action, meta)
	queue_free()

func open(slot: ShipSlot):
	for child in get_children():
		child.target = slot.current_structure_node
		child.pressed.connect(self.emit_action.bind(child.action, slot.current_structure))
		child.upd2(slot.current_structure)

	get_viewport().connect("gui_focus_changed", self.on_focus_changed)
