# @tool
extends Panel

@export var icon : Texture
@export var cost := 0
@export var action := "build"
@export var meta : Resource

@export var bg_color := Color("3b3b3bd6")

@export var value := 0
@export var label := ""

signal pressed()

func _gui_input(event):
	if has_focus() or event is InputEventMouse:
		if event.is_action_released("ui_accept") or event.is_action_released("mouse_left"):
			pressed.emit()

func _ready():
	upd()

# Too tired for this shit
func upd2(_meta):
	meta = _meta
	upd()

func upd():
	if meta == null:
		return

	var node : BaseTurret = meta.instantiate()

	%Icon.texture = icon
	cost = node.calculate_cost(action)
	if action == "build":
		%Label.text = node.name
	else:
		%Label.text = label

	%Cost.text = "%s$" % [cost]

	%Cost.add_theme_color_override("font_color", GameData.COLOR_GREEN)
	if action != "sell" && cost > GameData.money:
		%Cost.add_theme_color_override("font_color", GameData.COLOR_RED)

	if value == 0:
		size.y = 24
		%Extra.visible = false
	else:
		size.y = 48
		%Extra.visible = true
		%Value.text = "%s$" % [value]

	self_modulate = bg_color
