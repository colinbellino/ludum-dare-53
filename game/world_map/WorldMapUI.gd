class_name WorldMapUI extends CanvasItem

class WorldNode:
	var name: String
	var position: Vector2
	var color: Color
	var children: Array[WorldNode]
	var rect: Rect2
	var size: float

class DrawCall:
	var layer: int
	var proc

const OFFSET := Vector2(480, 50)
const SCALE := Vector2(80, 130)
const RECT_SIZE := 48
const colors : Array[Color] = [
	Color.RED,
	Color.PURPLE,
	Color.BEIGE,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.PINK,
	Color.ORANGE,
]
const names : Array[String] = [
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

var root : WorldNode
var font : Font
var button_skip : Button
var draw_calls : Array[DrawCall]
var selected_node: WorldNode

func _ready() -> void:
	button_skip = get_node("%Skip")
	button_skip.connect("pressed", button_skip_pressed)
	font = (get_node("Label") as Label).get_theme_font("font")

	root = make_world_node(Vector2(0, 0), "Boss")
	var node1 = make_world_node(Vector2(-1, 1))
	var node2 = make_world_node(Vector2(1, 1))
	var node3 = make_world_node(Vector2(-2, 2))
	var node4 = make_world_node(Vector2(0, 2))
	var node5 = make_world_node(Vector2(2, 2))
	var start1 = make_world_node(Vector2(-1, 3))
	var start2 = make_world_node(Vector2(1, 3))

	connect_node(root, node1)
	connect_node(root, node2)
	connect_node(node1, node3)
	connect_node(node1, node4)
	connect_node(node2, node4)
	connect_node(node2, node5)
	connect_node(node3, start1)
	connect_node(node4, start1)
	connect_node(node4, start2)
	connect_node(node5, start2)

func _process(_delta: float) -> void:
	queue_redraw()

	if Input.is_action_just_released("mouse_left"):
		Overlay.transition(Res.SCENE_LEVEL)

	if Input.is_action_just_released("debug_1"):
		Overlay.transition(Res.SCENE_WORLD_MAP)

func _draw() -> void:
	var nodes : Array[WorldNode] = [root]
	selected_node = null
	while nodes.size() > 0:
		var current = nodes.pop_front()
		var selected : bool = current.rect.has_point(get_viewport().get_mouse_position())
		if selected:
			selected_node = current
			var center : Vector2 = current.position + Vector2(-5 * current.name.length(), 30)
			add_draw_call(func(): draw_circle(current.position, current.size + 2, Color.WHITE), 0)
			add_draw_call(func(): draw_rect(Rect2(center.x, center.y, current.name.length() * 10 + 20, 30), Color(0.2, 0.2, 0.2, 1)), 3)
			add_draw_call(func(): draw_string(font, center + Vector2(15, 20), current.name, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color.WHITE), 4)

		add_draw_call(func(): draw_circle(current.position, current.size, current.color), 1)
		# add_draw_call(func(): draw_rect(current.rect, Color(1, 1, 1, 0.1)), 1)

		for child in current.children:
			add_draw_call(func(): draw_line(current.position, child.position, Color.WHITE, 1))
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

static func make_world_node(position: Vector2, node_name: String = "") -> WorldNode:
	var node = WorldNode.new()
	var rect_size := Vector2(RECT_SIZE, RECT_SIZE)
	if node_name == "":
		node.name = names[randi_range(0, names.size() - 1)]
	else:
		node.name = node_name
	node.position = (position + Vector2(randf_range(-0.2, 0.2), randf_range(-0.1, 0.1))) * SCALE + OFFSET
	node.color = colors[randi_range(0, colors.size() - 1 )]
	node.rect = Rect2(node.position - rect_size / 2, rect_size)
	node.size = randf_range(10, 15)
	return node

static func connect_node(from: WorldNode, to: WorldNode) -> void:
	from.children.append(to)
