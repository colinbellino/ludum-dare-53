extends Node2D

signal action_pressed(action, meta)

func _ready():
	for child in get_children():
		child.clicked.connect(self.emit_action.bind(child.action, child.meta))
		
func emit_action(action:String, meta = null):
	emit_signal("action_pressed", action, meta)
	queue_free()
