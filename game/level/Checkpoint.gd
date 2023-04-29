class_name Checkpoint extends Sprite2D

var area : Area2D
var was_reached : bool
var ui_root : Control
var ui_button_continue : Button
var ui_button_sell : Button

signal reached()
signal continue_pressed()

func _ready():
	area = get_node("%Area2D")
	area.connect("area_entered", on_area_entered)

	ui_root = get_node("%UI")
	ui_button_continue = get_node("%Continue")
	ui_button_continue.connect("pressed", on_continue_pressed)
	ui_button_sell = get_node("%Sell")

func _process(_delta: float):
	pass

func on_area_entered(other: Area2D):
	if was_reached == false && other.get_parent().name == "Cart":
		emit_signal("reached")
		was_reached = true

func on_continue_pressed():
	emit_signal("continue_pressed")

func ui_close():
	ui_root.visible = false

func ui_open():
	ui_root.visible = true
