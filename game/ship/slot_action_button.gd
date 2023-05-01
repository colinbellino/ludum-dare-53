@tool
extends Panel

signal pressed()

func _gui_input(event):
	if has_focus() or event is InputEventMouse:
		if event.is_action_released("ui_accept") or event.is_action_released("mouse_left"):
			pressed.emit()

@export var icon : Texture:
	set(val):
		icon = val
		upd()

@export var label := "":
	set(val):
		label = val
		upd()

@export var cost := 0:
	set(val):
		cost = val
		upd()

@export var action := "build"
@export var meta : Resource

@export var bg_color := Color("3b3b3bd6"):
	set(val):
		bg_color = val
		upd()

@export var value := 0:
	set(val):
		value = val
		upd()

# Called when the node enters the scene tree for the first time.
func _ready():
	upd()

func upd():
	if is_inside_tree():
		var node : BaseTurret = null
		if meta:
			node = meta.instantiate()
		%Icon.texture = icon
		if node:
			%Label.text = node.name
			%Cost.text = "%s$" % [node.cost]
		else:
			%Label.text = label
			%Cost.text = "%s$" % [cost]
		if node && node.cost > GameData.money:
			%Cost.add_theme_color_override("font_color", GameData.COLOR_RED)
		else:
			%Cost.add_theme_color_override("font_color", GameData.COLOR_GREEN)
		if value == 0:
			size.y = 24
			%Extra.visible = false
		else:
			size.y = 48
			%Extra.visible = true
			%Value.text = "%s$" % [value]
		self_modulate = bg_color
