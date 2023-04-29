extends Node

func _ready():
	get_tree().node_added.connect(self.setup_ui_node)
	var node_stack = get_tree().current_scene.get_children()
	while not node_stack.is_empty():
		var child = node_stack.pop_front()
		setup_ui_node(child)
		node_stack.append_array(child.get_children())

func setup_ui_node(new_node:Node)->void:
	if new_node is BaseButton:
		new_node.focus_entered.connect(self.ui_pointer)
		new_node.pressed.connect(self.ui_confirm)
		if get_viewport().gui_get_focus_owner() == null and new_node.focus_mode != 0:
			new_node.grab_focus()

func ui_pointer():
	# TODO: UI Feedback sounds
	pass

func ui_confirm():
	# TODO: UI Feedback sounds
	pass
