class_name WorldMapUI extends CanvasItem

class DrawCall:
	var layer: int
	var proc

const OFFSET := Vector2(480, 50)
const SCALE := Vector2(100, 130)
const RECT_SIZE := 48
const COLOR_NEXT     := Color.WHITE
const COLOR_PREVIOUS := Color.WHITE
const COLOR_SELECTED := Color.YELLOW
const COLOR_OTHER    := Color.DIM_GRAY
const COLOR_TEXT     := Color.WHITE

var colors : Array[Color] = [
	Color.RED,
	Color.PURPLE,
	Color.BLUE,
	Color.GREEN,
	Color.PINK,
	Color.TEAL,
	Color.DARK_RED,
]
var names : Array[String] = [
	"Huban 174",
	"Achil",
	"Waroros's Refuge",
	"Sotvis 52",
	"West Tacsea",
	"Fundalekon",
	"Ivacan",
	"Svalax",
	"Xyelialia",
	"Sidenol",
	"Svauram",
	"Theta Ibnt Moon",
	"Zingania 67",
	"Darkelos",
	"Naskien Quintus",
	"Anagatis",
	"Khanopia",
	"Talmburto 134",
	"Viscan IX",
	"West Kaaninax",
	"Epsilon Pycania",
	"Xypod",
	"Aveko Avlos Gamma",
	"The rock of Kneoid",
	"Patdania Gamma",
	"Beta Zedroid 12",
]
var font : Font
var button_skip : Button
var draw_calls : Array[DrawCall]
var selected_node: WorldNode

func _ready() -> void:
	button_skip = get_node("%Skip")
	button_skip.connect("pressed", button_skip_pressed)
	font = (get_node("Label") as Label).get_theme_font("font")

	if (GameData.map_previous_nodes.size() == 0):
		var root = make_world_node(Vector2(0, 0), "Boss")
		var node1 = make_world_node(Vector2(-1, 1))
		var node2 = make_world_node(Vector2(1, 1))
		var node3 = make_world_node(Vector2(-2, 2))
		var node4 = make_world_node(Vector2(0, 2))
		var node5 = make_world_node(Vector2(2, 2))
		var start = make_world_node(Vector2(0, 3))

		connect_node(root, node1)
		connect_node(root, node2)
		connect_node(node1, node3)
		connect_node(node1, node4)
		connect_node(node2, node4)
		connect_node(node2, node5)
		connect_node(node3, start)
		connect_node(node4, start)
		connect_node(node5, start)

		GameData.map_previous_nodes = [start]
		GameData.map_root = root

func _process(_delta: float) -> void:
	var current_node : WorldNode = GameData.map_previous_nodes[GameData.map_previous_nodes.size() - 1]
	if Input.is_action_just_released("mouse_left") && selected_node != null:
		if selected_node.children.has(current_node):
			GameData.map_previous_nodes.append(selected_node)
			AudioPlayer.play_ui_button_sound()
			if Input.is_key_pressed(KEY_SHIFT) == false:
				Overlay.transition(Res.SCENE_LEVEL)
			return
		else:
			AudioPlayer.play_ui_error_sound()

	if Input.is_action_just_released("debug_1"):
		GameData.map_previous_nodes = []
		Overlay.transition(Res.SCENE_WORLD_MAP)
		return

	queue_redraw()

func _draw() -> void:
	selected_node = null

	var nodes : Array[WorldNode] = [GameData.map_root]
	var current_node : WorldNode = GameData.map_previous_nodes[GameData.map_previous_nodes.size() - 1]
	while nodes.size() > 0:
		var node = nodes.pop_front()
		var center : Vector2 = node.position + Vector2(-5 * node.name.length(), 30)

		var is_selected : bool = node.rect.has_point(get_viewport().get_mouse_position())
		if is_selected:
			selected_node = node
			add_draw_call(func(): draw_circle(node.position, node.size + 5, COLOR_SELECTED), 1)
			add_draw_call(func(): draw_rect(Rect2(center.x, center.y, node.name.length() * 10 + 20, 30), Color(0.2, 0.2, 0.2, 1)), 3)
			add_draw_call(func(): draw_string(font, center + Vector2(15, 20), node.name, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, COLOR_TEXT), 4)
		else:
			if current_node.parents.size() > 0 && current_node.parents.has(node):
				add_draw_call(func(): draw_circle(node.position, node.size + 5, COLOR_NEXT), 1)

		var is_current : bool = node == current_node
		if is_current:
			add_draw_call(func(): draw_circle(node.position, node.size + 5, Color.ORANGE), 1)

		add_draw_call(func(): draw_circle(node.position, node.size, node.color), 2)
		# add_draw_call(func(): draw_rect(node.rect, Color(1, 1, 1, 0.1)), 99)

		for child in node.children:
			var color := COLOR_OTHER
			if node == selected_node && child == current_node:
				color = COLOR_SELECTED
			elif child == current_node:
				color = COLOR_NEXT
			elif GameData.map_previous_nodes.has(node) && GameData.map_previous_nodes.has(child):
				color = COLOR_PREVIOUS
			add_draw_call(func(): draw_line(node.position, child.position, color, 2), 0)
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

func button_skip_pressed() -> void:
	Overlay.transition(Res.SCENE_LEVEL)

func make_world_node(position: Vector2, node_name: String = "") -> WorldNode:
	var node = WorldNode.new()
	var rect_size := Vector2(RECT_SIZE, RECT_SIZE)
	if node_name == "":
		node.name = names[randi_range(0, names.size() - 1)]
		names.erase(node.name)
	else:
		node.name = node_name
	node.position = (position + Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2))) * SCALE + OFFSET
	node.color = colors[randi_range(0, colors.size() - 1 )]
	colors.erase(node.color)
	node.rect = Rect2(node.position - rect_size / 2, rect_size)
	node.size = randf_range(10, 15)
	return node

static func connect_node(from: WorldNode, to: WorldNode) -> void:
	from.children.append(to)
	to.parents.append(from)
