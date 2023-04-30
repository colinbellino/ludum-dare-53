extends Node2D

signal action_pressed(action, meta)

func _ready():
	for child in get_children():
		child.pressed.connect(self.emit_action.bind(child.action, child.meta))
	
	get_viewport().connect("gui_focus_changed", self.on_focus_changed)
		
func on_focus_changed(new_focus):
	if not is_ancestor_of(new_focus):
		queue_free()
		
func emit_action(action:String, meta = null):
	emit_signal("action_pressed", action, meta)
	queue_free()
