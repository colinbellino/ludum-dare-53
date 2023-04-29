extends Node

var num_modals_open = 0
var focus_stack = []

func transition(new_scene):
	# We can add a animation later here if we want
	var next_scene = load(new_scene)
	get_tree().change_scene_to_packed(next_scene)
	# We maybe need to close all modals here?

func show_modal(scene:PackedScene, pause : bool = true)->Node:
	if num_modals_open == 0 && pause:
		get_tree().paused = true
	num_modals_open += 1

	var focused = get_viewport().gui_get_focus_owner()
	focus_stack.push_back(focused)
	if focused != null:
		focused.release_focus()

	var node:Node = scene.instantiate()
	node.process_mode = PROCESS_MODE_ALWAYS
	add_child(node)
	node.tree_exited.connect(self.on_modal_closed)

	return node

func on_modal_closed():
	num_modals_open -= 1
	if num_modals_open == 0 and is_inside_tree():
		get_tree().paused = false

	var new_focus = focus_stack.pop_back()
	if new_focus and is_instance_valid(new_focus):
		new_focus.call_deferred("grab_focus")
