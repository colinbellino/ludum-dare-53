class_name ShipSlot
extends Area2D

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

func clear():
	if current_structure_node and is_instance_valid(current_structure_node):
		current_structure_node.queue_free()
		current_structure_node = null
	current_structure = null

func deselect():
	is_selected = false

func _input_event(_viewport:Viewport, event:InputEvent, _shape_idx:int):
	if event.is_action_pressed("mouse_left"):
		for obj in get_tree().get_nodes_in_group("Selectable"):
			is_selected = false

		if not is_selected:
			is_selected = true
			emit_signal("selected")

	if OS.is_debug_build():
		# Debug code to simulate take cargo
		if event.is_action_pressed("mouse_middle"):
			if current_structure_node == null:
				var meta := preload("res://game/turrets/Cargo.tscn")
				GameData.level.ship.player_action("build", meta, self)

		# Debug code to simulate damage
		if event.is_action_pressed("mouse_right"):
			if current_structure_node:
				current_structure_node.take_hit(100)
