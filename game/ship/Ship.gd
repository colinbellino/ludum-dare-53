class_name Ship extends Node2D

@export var movement_speed : Vector2 = Vector2(0, -100)

var health_max : int
var health_current : int

var _current_ui_node : Node2D
var _menu_construct : InstancePlaceholder
var _menu_repair : InstancePlaceholder

const HEALTH_BY_SLOT : int = 4

func _ready() -> void:
	_menu_construct = get_node("%ConstructMenu")
	_menu_repair = get_node("%RepairMenu")

	for child in get_tree().get_nodes_in_group("Selectable"):
		if is_ancestor_of(child) and child is ShipSlot && child.get_parent().visible:
			child.connect("selected", slot_selected.bind(child))
			child.connect("damaged", slot_damaged)
			health_max += HEALTH_BY_SLOT

func slot_selected(slot: ShipSlot) -> void:
	if _current_ui_node and is_instance_valid(_current_ui_node):
		_current_ui_node.free()
		_current_ui_node = null

	var ui_scene : InstancePlaceholder = _menu_construct if not slot.current_structure else _menu_repair
	var node = ui_scene.create_instance()
	node.global_position = slot.global_position
	node.open(slot)
	node.action_pressed.connect(self.player_action.bind(slot))
	_current_ui_node = node

func slot_damaged(damage: int) -> void:
	health_current = max(health_current - damage, 0)

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
