extends Node2D

signal action_pressed(action, meta)

func _ready():
	$Close.connect("pressed", close_menu)

func close_menu():
	queue_free()

func on_focus_changed(new_focus):
	if not is_ancestor_of(new_focus):
		queue_free()

func emit_action(child):
	emit_signal("action_pressed", child.action, child.meta)
	queue_free()

func open(slot: ShipSlot):
	for child in get_children():
		if child is Button:
			continue
		child.pressed.connect(self.emit_action.bind(child))

	if GameData.level:
		$Cargo.visible = (GameData.level.state == Level.LevelStates.CHECKPOINT)
		$DangerCargo.visible = (GameData.level.state == Level.LevelStates.CHECKPOINT)

	get_viewport().connect("gui_focus_changed", self.on_focus_changed)
