class_name ShipSlot
extends Area2D

var health_bar : ProgressBar

signal selected()

@export var current_structure:PackedScene = null
@export var health = 1.0 # Percentage health, scales with max health of structure

var current_structure_node = null

var is_selected = false

func _ready():
	health_bar = get_node("%HealthBar")
	health_bar.visible = false
	add_to_group("Selectable")
	if current_structure:
		build_structure(current_structure, true)

func build_structure(new_structure:PackedScene, initial_build = false):
	clear()
	health = 1.0

	var node : BaseTurret = new_structure.instantiate()

	if initial_build == false:
		if node.cost > GameData.money:
			AudioPlayer.play_ui_error_sound()
			return

		GameData.money -= node.cost
		AudioPlayer.play_ui_turret_sound()

	current_structure = new_structure
	current_structure_node = node
	current_structure_node.connect("damaged", on_structure_damaged)
	add_child(current_structure_node)

func sell():
	GameData.money += current_structure_node.cost / 2
	AudioPlayer.play_ui_money_sound()
	clear()

func clear():
	health_bar.visible = false
	if current_structure_node and is_instance_valid(current_structure_node):
		current_structure_node.disconnect("damaged", on_structure_damaged)
		current_structure_node.queue_free()
		current_structure_node = null
	current_structure = null

func destroy():
	if current_structure_node and is_instance_valid(current_structure_node):
		if current_structure_node.debris_sprite != null:
			$Sprite2D.texture = current_structure_node.debris_sprite
			$Sprite2D.self_modulate = Color.GRAY
	clear()

func deselect():
	is_selected = false

func on_structure_damaged(_damage: float):
	var value : float = current_structure_node.hitpoints / current_structure_node.max_hitpoints
	var bg = health_bar.get("theme_override_styles/fill").duplicate()

	health_bar.visible = true
	health_bar.value = value
	bg.bg_color = GameData.COLOR_GREEN
	if value < 0.66:
		bg.bg_color = GameData.COLOR_ORANGE
	if value < 0.33:
		bg.bg_color = GameData.COLOR_RED
	health_bar.set("theme_override_styles/fill", bg)

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
				current_structure_node.take_hit(10)
