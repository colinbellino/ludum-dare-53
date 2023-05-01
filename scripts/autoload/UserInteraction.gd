extends Node

func _ready():
	get_tree().node_added.connect(self.setup_ui_node)
	var node_stack = get_tree().current_scene.get_children()
	while not node_stack.is_empty():
		var child = node_stack.pop_front()
		setup_ui_node(child)
		node_stack.append_array(child.get_children())

func setup_ui_node(new_node:Node)->void:
	if new_node is Control:
		if new_node.focus_mode == Control.FOCUS_ALL:
			new_node.focus_entered.connect(self.ui_pointer)
			if new_node.has_signal("pressed"):
				new_node.pressed.connect(self.ui_confirm)
			if get_viewport().gui_get_focus_owner() == null:
				new_node.grab_focus()

func ui_pointer():
	AudioPlayer.play_ui_hover_sound()

func ui_confirm():
	AudioPlayer.play_ui_button_sound()
