class_name Ship extends Node2D

@export var movement_speed : Vector2 = Vector2(0, -100)
@export var movement_mult : float = 1.0

var current_ui_node : Node2D
var menu_construct : InstancePlaceholder
var menu_repair : InstancePlaceholder

func _ready() -> void:
	menu_construct = get_node("%ConstructMenu")
	menu_repair = get_node("%RepairMenu")

	for node in get_tree().get_nodes_in_group("Selectable"):
		if is_ancestor_of(node) and node is ShipSlot:
			node.connect("selected", self.on_slot_selected.bind(node))

func on_slot_selected(slot: ShipSlot) -> void:
	if current_ui_node and is_instance_valid(current_ui_node):
		current_ui_node.free()
		current_ui_node = null

	var ui_scene : InstancePlaceholder = menu_construct if not slot.current_structure else menu_repair
	var node = ui_scene.create_instance()
	node.global_position = slot.global_position
	node.open(slot)
	node.action_pressed.connect(self.player_action.bind(slot))
	current_ui_node = node

func player_action(action_name: String, meta: PackedScene, target: ShipSlot) -> void:
	match action_name:
		"build":
			target.build_structure(meta)
		"sell":
			target.sell()
		"repair":
			target.repair()
		_:
			print("Action not implemented yet: ", action_name)
			AudioPlayer.play_ui_error_sound()
