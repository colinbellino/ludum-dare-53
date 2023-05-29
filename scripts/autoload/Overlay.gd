extends Node

var num_modals_open : int = 0
var focus_stack : Array[Node] = []

func transition(next_scene: PackedScene) -> void:
	# We can add a animation later here if we want
	get_tree().change_scene_to_packed(next_scene)
	# We maybe need to close all modals here?
	focus_stack = []

func show_modal(next_scene: PackedScene, pause : bool = true) -> Node:
	if num_modals_open == 0 && pause:
		get_tree().paused = true
	num_modals_open += 1

	var focused = get_viewport().gui_get_focus_owner()
	focus_stack.push_back(focused)
	if focused != null:
		focused.release_focus()

	var node : Node = next_scene.instantiate()
	# node.process_mode = PROCESS_MODE_ALWAYS
	node.tree_exited.connect(self.on_modal_closed)
	add_child(node)

	return node

func on_modal_closed() -> void:
	num_modals_open -= 1
	if num_modals_open == 0 and is_inside_tree():
		get_tree().paused = false

	var new_focus = focus_stack.pop_back()
	if new_focus and is_instance_valid(new_focus):
		new_focus.call_deferred("grab_focus")
