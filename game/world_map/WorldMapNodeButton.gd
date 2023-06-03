class_name WorldMapNodeButton extends TextureButton

var panel_tooltip : Panel
var label_name : Label

func _ready() -> void:
	# self.connect("focus_entered", _mouse_entered)
	self.connect("mouse_entered", _mouse_entered)
	# self.connect("focus_exited", _focus_exited)
	self.connect("mouse_exited", _mouse_exited)
	panel_tooltip = get_node("%Tooltip")
	panel_tooltip.visible = false
	label_name = get_node("%Name")

func _mouse_entered() -> void:
	panel_tooltip.visible = true

func _mouse_exited() -> void:
	panel_tooltip.visible = false
