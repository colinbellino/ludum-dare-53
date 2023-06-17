class_name WorldMapNodeButton extends Control

var panel_tooltip : Panel
var label_name : Label
var button : TextureButton
var node: WorldMapNode

func _ready() -> void:
	panel_tooltip = get_node("%Tooltip")
	panel_tooltip.visible = false
	label_name = get_node("%Name")
	button = get_node("%Button")
	button.connect("mouse_entered", _mouse_entered)
	button.connect("mouse_exited", _mouse_exited)
	button.connect("focus_entered", _mouse_entered)
	button.connect("focus_exited", _mouse_exited)

func _mouse_entered() -> void:
	button.grab_focus()
	panel_tooltip.visible = true

func _mouse_exited() -> void:
	button.release_focus()
	panel_tooltip.visible = false
