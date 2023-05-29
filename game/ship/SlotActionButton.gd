class_name SlotActionButton extends Panel

@export var icon : Texture
@export var cost : int = 0
@export var action : String = "build"
@export var meta : Resource
@export var bg_color : Color = Color("3b3b3bd6")
@export var value : int = 0
@export var label : String = ""

var target : ShipSlot
var control_extra : Control
var label_name : Label
var label_cost : Label
var label_value : Label
var texture_icon : TextureRect

signal pressed()

func _ready() -> void:
	control_extra = get_node("%Extra")
	label_name = get_node("%Label")
	label_cost = get_node("%Cost")
	label_value = get_node("%Cost")
	texture_icon = get_node("%Icon")
	upd()

func _gui_input(event) -> void:
	if has_focus() or event is InputEventMouse:
		if event.is_action_released("ui_accept") or event.is_action_released("mouse_left"):
			pressed.emit()

func upd2(_meta: PackedScene) -> void:
	meta = _meta
	upd()

func upd() -> void:
	texture_icon.texture = icon
	if target:
		cost = target.calculate_cost(action)
	elif action == "build":
		cost = GameData.scene_properties[meta.resource_path].cost
	label_name.text = label

	label_cost.text = "%s$" % [cost]

	label_cost.add_theme_color_override("font_color", GameData.COLOR_GREEN)
	if action != "sell" && cost > GameData.money:
		label_cost.add_theme_color_override("font_color", GameData.COLOR_RED)

	if value == 0:
		size.y = 24
		control_extra.visible = false
	else:
		size.y = 48
		control_extra.visible = true
		label_value.text = "%s$" % [value]

	self_modulate = bg_color
