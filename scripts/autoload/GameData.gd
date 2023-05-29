extends Node

# TODO: Move to Game.gd
const PHYSICS_LAYER_MONSTER_HURTABLE := 4
const PHYSICS_LAYER_SHIP_HURTABLE := 2
const PHYSICS_LAYER_BLOCKER := 1
const PHYSICS_LAYER_HURTABLE := PHYSICS_LAYER_MONSTER_HURTABLE | PHYSICS_LAYER_SHIP_HURTABLE
const STARTING_MONEY := 200

var COLOR_GREEN : Color = Color.html("33cc73")
var COLOR_ORANGE : Color = Color.html("c5cc28")
var COLOR_RED : Color = Color.html("a02c1b")
var scene_properties : Dictionary = {}
var scene_by_category : Dictionary = {}
var category_defaults : Dictionary = {}
var money : float # Initialized in Level.ready
var voice_played : bool
var cheat_invincible : bool
var cheat_skip_checkpoint : bool

func _ready() -> void:
	add_category("Turrets", BaseTurret)
	add_to_db("Turrets", Res.TURRET_PLASMA)
	add_to_db("Turrets", Res.TURRET_DISRUPTOR)
	add_to_db("Turrets", Res.TURRET_RAILBEAM)
	add_to_db("Turrets", Res.TURRET_PLATING)
	add_to_db("Turrets", Res.TURRET_CARGO)
	add_to_db("Turrets", Res.TURRET_CARGO_DANGEROUS)

func add_to_db(category: String, scene: PackedScene) -> void:
	var properties = category_defaults[category].duplicate()
	# Scene overrides
	var scene_state = scene.get_state()
	var node_id = 0 # We just assume that the first node inside the scene file is the root.
	var num_properties = scene_state.get_node_property_count(node_id)
	for i in num_properties:
		var value = scene_state.get_node_property_value(node_id, i)
		properties[scene_state.get_node_property_name(node_id, i)] = value
	scene_properties[scene.resource_path] = properties
	scene_by_category[category].push_back(scene.resource_path)

func add_category(category: String, base_class: Script) -> void:
	scene_by_category[category] = []
	var defaults = {}
	var instance = base_class.new()
	for p in base_class.get_script_property_list():
		if (p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) and (p.usage & PROPERTY_USAGE_STORAGE):
			defaults[p.name] = instance.get(p.name)
	instance.free()
	category_defaults[category] = defaults
