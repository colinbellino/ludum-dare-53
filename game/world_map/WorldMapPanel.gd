class_name WorldMapPanel extends Panel

@export var font : Font

const SCALE          := Vector2(0.1, 0.25)
const OFFSET         := Vector2(0.5, 0.1)
const RECT_SIZE      := Vector2(48, 48)
const COLOR_NEXT     := Color.WHITE
const COLOR_PREVIOUS := Color.WHITE
const COLOR_SELECTED := Color.YELLOW
const COLOR_OTHER    := Color.DIM_GRAY
const COLOR_TEXT     := Color.WHITE

var selected_node: WorldMapNode
var nodes: Dictionary

signal node_selected(node)

# TODO: Node Hover
# TODO: Node Active
# TODO: Line Active
# TODO: Line Hover
func init(root_node: WorldMapNode) -> void:
	var nodes_created : Array[WorldMapNode] = []
	var nodes_to_create : Array[WorldMapNode] = [root_node]
	var current_node : WorldMapNode = GameData.map_previous_nodes[GameData.map_previous_nodes.size() - 1]

	while nodes_to_create.size() > 0:
		var node : WorldMapNode = nodes_to_create.pop_back()

		var node_button : WorldMapNodeButton = Res.WORLD_MAP_NODE_BUTTON.instantiate()
		add_child(node_button)
		node_button.node = node
		node_button.name = node.name
		node_button.label_name.text = node.name
		node_button.position = _scale_position(node.position)
		node_button.button.connect("pressed", _node_pressed.bind(node))
		node_button.button.disabled = current_node.parents.size() == 0 || current_node.parents.has(node) == false
		if node_button.button.disabled:
			node_button.button.focus_mode = Control.FOCUS_NONE
		else:
			node_button.button.grab_focus()
		# node_button.connect("mouse_entered", _node_mouse_entered.bind(node))
		# node_button.connect("mouse_exited", _node_mouse_exited.bind(node))
		# node_button.modulate = node.color

		# print(node.name)
		# print("children", node.children.map(func(a): return a.name))
		# print("parents ", node.parents.map(func(a): return a.name))

		for child in node.children:
			var line := Line2D.new()
			line.width = 2
			line.add_point(Vector2.ZERO)
			line.add_point(_scale_position(child.position) - _scale_position(node.position))
			line.default_color = Color.DIM_GRAY
			if child == current_node:
				line.default_color = Color.WHITE
			elif GameData.map_previous_nodes.has(node) && GameData.map_previous_nodes.has(child):
				line.default_color = Color.WHITE
			node_button.add_child(line)
			if nodes_created.has(child) == false:
				nodes_to_create.push_back(child)

		nodes_created.push_back(node)

func _scale_position(_position: Vector2) -> Vector2:
	return _position * (size * SCALE) + (size * OFFSET)

func _node_mouse_entered(node: WorldMapNode) -> void:
	print("_node_mouse_entered: ", node)
	# selected_node = node

func _node_mouse_exited(node: WorldMapNode) -> void:
	print("_node_mouse_exited: ", node)
	# selected_node = null

func _node_pressed(node: WorldMapNode) -> void:
	var current_node : WorldMapNode = GameData.map_previous_nodes[GameData.map_previous_nodes.size() - 1]
	if Input.is_action_just_released("mouse_left") && node != null:
		if node.children.has(current_node):
			GameData.map_previous_nodes.append(node)
			AudioPlayer.play_ui_button_sound()
			if Input.is_key_pressed(KEY_SHIFT) == false:
				emit_signal("node_selected", node)
		else:
			AudioPlayer.play_ui_error_sound()