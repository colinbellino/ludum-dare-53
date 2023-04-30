class_name Ship extends Node2D

@export var money := 100
@export var movement_speed := Vector2(0, -100)
@export var movement_mult := 1.0

var current_ui_node = null

func _ready():
	for child in get_children():
		if child is ShipSlot:
			child.connect("selected", self.on_slot_selected.bind(child))

func _process(delta):
	position += movement_speed * movement_mult * delta

func on_slot_selected(slot:ShipSlot):
	if current_ui_node:
		current_ui_node.free()
		current_ui_node = null
	
	var ui_scene = $ConstructMenu if slot.current_structure else $RepairMenu
	var node = ui_scene.instantiate()
	
	node.action_pressed.connect(self.player_action.bind(slot))
	
func player_action(target:ShipSlot, action_name:String, meta = null):
	var old_structure = target.current_structure
	var old_health = target.health
	match action_name:
		"buy":
			target.build_structure(meta)
		"sell":
			target.tear_down_structure()
