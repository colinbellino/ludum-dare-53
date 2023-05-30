class_name WorldMapUI extends CanvasItem

class WorldNode:
	var name: String
	var position: Vector2
	var color: Color
	var children: Array[WorldNode]

const OFFSET := Vector2(480, 50)
const SCALE := Vector2(80, 130)
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

func _ready() -> void:
	button_skip = get_node("%Skip")
	button_skip.connect("pressed", button_skip_pressed)
	font = (get_node("Label") as Label).get_theme_font("font")

	root = WorldNode.new()
	root.name = "Boss"
	root.position = Vector2(0, 0) + Vector2(randf_range(-0.2, 0.2), randf_range(-0.1, 0.1))
	root.color = colors[randi_range(0, colors.size() - 1 )]

	var node1 = WorldNode.new()
	node1.name = names[randi_range(0, names.size() - 1)]
	node1.position = Vector2(-1, 1) + Vector2(randf_range(-0.2, 0.2), randf_range(-0.1, 0.1))
	node1.color = colors[randi_range(0, colors.size() - 1 )]
	var node2 = WorldNode.new()
	node2.name = names[randi_range(0, names.size() - 1)]
	node2.position = Vector2(1, 1) + Vector2(randf_range(-0.2, 0.2), randf_range(-0.1, 0.1))
	node2.color = colors[randi_range(0, colors.size() - 1 )]

	var node3 = WorldNode.new()
	node3.name = names[randi_range(0, names.size() - 1)]
	node3.position = Vector2(-2, 2) + Vector2(randf_range(-0.2, 0.2), randf_range(-0.1, 0.1))
	node3.color = colors[randi_range(0, colors.size() - 1 )]
	var node4 = WorldNode.new()
	node4.name = names[randi_range(0, names.size() - 1)]
	node4.position = Vector2(0, 2) + Vector2(randf_range(-0.2, 0.2), randf_range(-0.1, 0.1))
	node4.color = colors[randi_range(0, colors.size() - 1 )]
	var node5 = WorldNode.new()
	node5.name = names[randi_range(0, names.size() - 1)]
	node5.position = Vector2(2, 2) + Vector2(randf_range(-0.2, 0.2), randf_range(-0.1, 0.1))
	node5.color = colors[randi_range(0, colors.size() - 1 )]

	var start1 = WorldNode.new()
	start1.name = names[randi_range(0, names.size() - 1)]
	start1.position = Vector2(-1, 3) + Vector2(randf_range(-0.2, 0.2), randf_range(-0.1, 0.1))
	start1.color = colors[randi_range(0, colors.size() - 1 )]
	var start2 = WorldNode.new()
	start2.name = names[randi_range(0, names.size() - 1)]
	start2.position = Vector2(1, 3) + Vector2(randf_range(-0.2, 0.2), randf_range(-0.1, 0.1))
	start2.color = colors[randi_range(0, colors.size() - 1 )]

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

	queue_redraw()

func _process(delta: float) -> void:
	# queue_redraw()

	if Input.is_action_just_released("debug_1"):
		Overlay.transition(Res.SCENE_WORLD_MAP)

func _draw() -> void:
	var nodes : Array[WorldNode] = [root]
	while nodes.size() > 0:
		var current = nodes.pop_front()
		draw_circle(to_draw_position(current.position), 10, current.color)
		draw_string_outline(font, to_draw_position(current.position) + Vector2(-5 * current.name.length(), 30), current.name, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, 10, Color.BLACK)
		draw_string(font, to_draw_position(current.position) + Vector2(-5 * current.name.length(), 30), current.name, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color.WHITE)
		for child in current.children:
			if child != null:
				draw_line(to_draw_position(current.position), to_draw_position(child.position), Color.WHITE, 1)
				nodes.push_back(child)

func button_skip_pressed() -> void:
	Overlay.transition(Res.SCENE_LEVEL)

func connect_node(from: WorldNode, to: WorldNode) -> void:
	from.children.append(to)

func to_draw_position(position: Vector2) -> Vector2:
	return position * SCALE + OFFSET
