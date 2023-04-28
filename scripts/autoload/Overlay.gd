extends Node

var num_modals_open = 0

func transition(new_scene):
	# We can add a animation later here if we want
	var next_scene = load(new_scene)
	get_tree().change_scene_to_packed(next_scene)

func show_modal(scene:PackedScene)->Node:
	if num_modals_open == 0:
		get_tree().paused = true
	num_modals_open += 1
	
	var node:Node = scene.instantiate()
	node.process_mode = PROCESS_MODE_ALWAYS
	add_child(node)
	node.tree_exited.connect(self.on_modal_closed)
	return node
	
func on_modal_closed():
	num_modals_open -= 1
	if num_modals_open == 0:
		get_tree().paused = false
