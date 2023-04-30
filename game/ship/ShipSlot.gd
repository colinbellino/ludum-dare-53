class_name ShipSlot
extends StaticBody2D

signal selected()

@export var current_structure:PackedScene = null
@export var health = 1.0 # Percentage health, scales with max health of structure

var current_structure_node = null

var is_selected = false

func _ready():
	add_to_group("Selectable")
	if current_structure:
		build_structure(current_structure)
	
func build_structure(new_structure:PackedScene):
	clear()
	health = 1.0
	current_structure = new_structure
	current_structure_node = current_structure.instantiate()
	add_child(current_structure_node)
	$CollisionShape2D.disabled = false
	
func clear():
	if current_structure_node and is_instance_valid(current_structure_node):
		current_structure_node.free()
		current_structure_node = null
		$CollisionShape2D.disabled = true

func deselect():
	is_selected = false

func _input_event(_viewport:Viewport, event:InputEvent, _shape_idx:int):
	if event.is_action_pressed("mouse_left"):
		for obj in get_tree().get_nodes_in_group("Selectable"):
			is_selected = false
			
		if not is_selected:
			is_selected = true
			emit_signal("selected")
