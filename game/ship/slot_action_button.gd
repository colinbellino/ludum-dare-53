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

@export var cost := 50:
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
		%Icon.texture = icon
		%Label.text = label
		%Cost.text = "%s$" % [cost]
		if cost > 0:
			%Cost.add_theme_color_override("font_color", Color.CORNFLOWER_BLUE)
		else:
			%Cost.add_theme_color_override("font_color", Color.FOREST_GREEN)
		if value == 0:
			size.y = 24
			%Extra.visible = false
		else:
			size.y = 48
			%Extra.visible = true
			%Value.text = "%s$" % [value]
		self_modulate = bg_color