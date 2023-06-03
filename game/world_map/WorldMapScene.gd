class_name WorldMapScene extends CanvasItem

var colors : Array[Color] = [
	Color.RED,
	Color.PURPLE,
	Color.BLUE,
	Color.GREEN,
	Color.TEAL,
	Color.DARK_RED,
	Color.ORANGE,
	Color.BROWN,
	Color.CRIMSON,
	Color.GREEN_YELLOW,
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
var button_skip : Button
var panel_map : WorldMapPanel

# FIXME: this is leaking at can crash the game after a few resets
func _ready() -> void:
	button_skip = get_node("%Skip")
	button_skip.connect("pressed", button_skip_pressed)
	panel_map = get_node("%WorldMap")
	panel_map.connect("node_selected", map_node_selected)

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
		panel_map.init(GameData.map_root)

func _process(_delta: float) -> void:
	if Input.is_action_just_released("debug_1"):
		GameData.map_previous_nodes = []
		free()
		Overlay.show_modal(Res.SCENE_WORLD_MAP)

func button_skip_pressed() -> void:
	queue_free()

func map_node_selected(_selected_node: WorldMapNode) -> void:
	queue_free()

func make_world_node(position: Vector2, node_name: String = "") -> WorldMapNode:
	var node = WorldMapNode.new()
	if node_name == "":
		node.name = names[randi_range(0, names.size() - 1)]
		names.erase(node.name)
	else:
		node.name = node_name
	node.position = (position + Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2)))
	node.color = colors[randi_range(0, colors.size() - 1 )]
	colors.erase(node.color)
	node.size = randf_range(10, 15)
	return node

static func connect_node(from: WorldMapNode, to: WorldMapNode) -> void:
	from.children.append(to)
	to.parents.append(from)
