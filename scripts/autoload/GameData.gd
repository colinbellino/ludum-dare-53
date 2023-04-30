extends Node

var scene_properties := {}
var scene_by_category := {}
var category_defaults := {}
var level: Level

func _ready():
	add_category("Turrets", BaseTurret)
	add_to_db("Turrets", preload("res://game/cart/LightMGTurret.tscn"))

func add_to_db(category:String, scene:PackedScene):
	var properties = category_defaults[category].duplicate()
	# Scene overrides
	var scene_state = scene.get_state()
	var node_id = 0 # We just assume that the first node inside the scene file is the root.
	var num_properties = scene_state.get_node_property_count(node_id)
	for i in num_properties:
		var value = scene_state.get_node_property_value(node_id, i)
		properties[scene_state.get_node_property_name(node_id, i)] = value
	scene_properties[scene] = properties
	scene_by_category[category].push_back(scene)

func add_category(category:String, base_class:Script):
	scene_by_category[category] = []
	var defaults = {}
	for p in base_class.get_script_property_list():
		if (p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) and (p.usage & PROPERTY_USAGE_STORAGE):
			defaults[p.name] = base_class.get_property_default_value(p.name)
	category_defaults[category] = defaults

