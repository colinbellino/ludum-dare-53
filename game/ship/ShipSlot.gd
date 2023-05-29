class_name ShipSlot extends Area2D

@export var current_structure : PackedScene
@export var health : float = 1.0 # Percentage health, scales with max health of structure

var health_bar : ProgressBar
var sprite : Sprite2D
var current_structure_node : Node
var is_selected : bool

signal selected()

func _ready() -> void:
	health_bar = get_node("%HealthBar")
	health_bar.visible = false
	sprite = get_node("%Sprite2D")

	add_to_group("Selectable")
	if current_structure:
		build_structure(current_structure, true)

func build_structure(new_structure: PackedScene, initial_build : bool = false) -> void:
	clear()
	health = 1.0

	var node : Object = new_structure.instantiate() as Object

	if initial_build == false:
		if node.cost > GameData.money:
			AudioPlayer.play_ui_error_sound()
			return

		GameData.money -= node.cost
		if node is Cargo:
			AudioPlayer.play_sound(Res.SFX_PLACE_CARGO);
		else:
			AudioPlayer.play_sound(Res.SFX_PLACE_TURRET);

	current_structure = new_structure
	current_structure_node = node
	current_structure_node.connect("damaged", on_structure_damaged)
	add_child(current_structure_node)

func sell() -> void:
	GameData.money += current_structure_node.calculate_cost("sell")
	AudioPlayer.play_ui_money_sound()
	clear()

func repair() -> void:
	GameData.money -= current_structure_node.calculate_cost("repair")
	current_structure_node.hitpoints = current_structure_node.max_hitpoints
	AudioPlayer.play_ui_repair_sound()
	update_healthbar()

func clear() -> void:
	health_bar.visible = false
	if current_structure_node and is_instance_valid(current_structure_node):
		current_structure_node.disconnect("damaged", on_structure_damaged)
		current_structure_node.queue_free()
		current_structure_node = null
	current_structure = null

func destroy() -> void:
	if current_structure_node and is_instance_valid(current_structure_node):
		if current_structure_node.debris_sprite != null:
			sprite.texture = current_structure_node.debris_sprite
			sprite.self_modulate = Color.GRAY
	clear()

func deselect() -> void:
	is_selected = false

func on_structure_damaged(_damage: float) -> void:
	update_healthbar()

func update_healthbar() -> void:
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

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
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
				var meta := Res.TURRET_CARGO
				GameData.level.ship.player_action("build", meta, self)

		# Debug code to simulate damage
		if event.is_action_pressed("mouse_right"):
			if current_structure_node:
				current_structure_node.take_hit(10)
