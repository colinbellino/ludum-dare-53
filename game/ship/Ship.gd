class_name Ship extends AnimatableBody2D

@export var movement_speed := Vector2(0, -100)
@export var movement_mult := 1.0

var velocity : Vector2
var current_ui_node = null

func _ready():
	for node in get_tree().get_nodes_in_group("Selectable"):
		if is_ancestor_of(node) and node is ShipSlot:
			node.connect("selected", self.on_slot_selected.bind(node))

func _process(_delta):
	velocity = movement_speed * movement_mult
	position += velocity * _delta

func on_slot_selected(slot:ShipSlot):
	if current_ui_node and is_instance_valid(current_ui_node):
		current_ui_node.free()
		current_ui_node = null

	var ui_scene : InstancePlaceholder = %ConstructMenu if not slot.current_structure else %RepairMenu
	var node = ui_scene.create_instance()
	node.global_position = slot.global_position
	node.open(slot)
	node.action_pressed.connect(self.player_action.bind(slot))
	current_ui_node = node

func player_action(action_name:String, meta, target:ShipSlot):
	var old_structure = target.current_structure
	var old_health = target.health
	match action_name:
		"build":
			target.build_structure(meta)
		"sell":
			target.sell()
		_:
			print("Actiion not implemented yet")
			AudioPlayer.play_ui_error_sound()
