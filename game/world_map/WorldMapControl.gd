class_name WorldMapControl extends ColorRect

class DrawCall:
	var layer: int
	var proc

@export var font : Font

const SCALE          := Vector2(0.2, 0.25)
const OFFSET         := Vector2(0.5, 0.1)
const RECT_SIZE      := Vector2(48, 48)
const COLOR_NEXT     := Color.WHITE
const COLOR_PREVIOUS := Color.WHITE
const COLOR_SELECTED := Color.YELLOW
const COLOR_OTHER    := Color.DIM_GRAY
const COLOR_TEXT     := Color.WHITE

var draw_calls : Array[DrawCall]
var selected_node: WorldNode

signal node_selected(node)

func _process(_delta: float) -> void:
	if GameData.map_previous_nodes.size() == 0:
		return

	var current_node : WorldNode = GameData.map_previous_nodes[GameData.map_previous_nodes.size() - 1]
	if Input.is_action_just_released("mouse_left") && selected_node != null:
		if selected_node.children.has(current_node):
			GameData.map_previous_nodes.append(selected_node)
			AudioPlayer.play_ui_button_sound()
			if Input.is_key_pressed(KEY_SHIFT) == false:
				emit_signal("node_selected", selected_node)
		else:
			AudioPlayer.play_ui_error_sound()

	queue_redraw()
	selected_node = null

func _draw() -> void:
	if GameData.map_previous_nodes.size() == 0:
		return

	var mouse_position := get_viewport().get_mouse_position() - position
	# add_draw_call(func(): draw_rect(Rect2(mouse_position - Vector2(10, 10) / 2, Vector2(10, 10)), Color(1, 1, 1, 0.1)), 99)

	var nodes : Array[WorldNode] = [GameData.map_root]
	var current_node : WorldNode = GameData.map_previous_nodes[GameData.map_previous_nodes.size() - 1]
	while nodes.size() > 0:
		var node = nodes.pop_front()
		var scaled_position = node.position * (size * SCALE) + (size * OFFSET)
		var center : Vector2 = scaled_position + Vector2(-5 * node.name.length(), 30)

		var node_rect = Rect2(scaled_position - RECT_SIZE / 2, RECT_SIZE)
		var is_selected : bool = node_rect.has_point(mouse_position)
		if is_selected:
			selected_node = node
			add_draw_call(func(): draw_circle(scaled_position, node.size + 5, COLOR_SELECTED), 1)
			add_draw_call(func(): draw_rect(Rect2(center.x, center.y, node.name.length() * 10 + 20, 30), Color(0.2, 0.2, 0.2, 1)), 3)
			add_draw_call(func(): draw_string(font, center + Vector2(15, 20), node.name, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, COLOR_TEXT), 4)
		else:
			if current_node.parents.size() > 0 && current_node.parents.has(node):
				add_draw_call(func(): draw_circle(scaled_position, node.size + 5, COLOR_NEXT), 1)

		var is_current : bool = node == current_node
		if is_current:
			add_draw_call(func(): draw_circle(scaled_position, node.size + 5, Color.ORANGE), 1)

		add_draw_call(func(): draw_circle(scaled_position, node.size, node.color), 2)
		# add_draw_call(func(): draw_rect(node_rect, Color(1, 1, 1, 0.1)), 99)

		for child in node.children:
			var line_color := COLOR_OTHER
			if node == selected_node && child == current_node:
				line_color = COLOR_SELECTED
			elif child == current_node:
				line_color = COLOR_NEXT
			elif GameData.map_previous_nodes.has(node) && GameData.map_previous_nodes.has(child):
				line_color = COLOR_PREVIOUS
			add_draw_call(func(): draw_line(scaled_position, child.position * (size * SCALE) + (size * OFFSET), line_color, 2), 0)
			nodes.push_back(child)

	draw_calls.sort_custom(custom_array_sort)
	for draw_call in draw_calls:
		draw_call.proc.call()

	draw_calls.clear()

func add_draw_call(proc, layer : int = 0) -> void:
	var draw_call := DrawCall.new()
	draw_call.proc = proc
	draw_call.layer = layer
	draw_calls.push_back(draw_call)

func custom_array_sort(a: DrawCall, b: DrawCall) -> bool:
	return a.layer < b.layer
