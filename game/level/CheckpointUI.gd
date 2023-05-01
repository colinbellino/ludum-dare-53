class_name CheckpointUI extends Control

var ui_root : Control
var ui_button_continue : Button
var ui_button_sell : Button
var ui_label_title : Label

signal continue_pressed()

func _ready():
	ui_root = get_node("%CheckpointUI")
	assert(ui_root != null, "Missing ui_root in CheckpointUI.")
	ui_button_continue = get_node("%Continue")
	assert(ui_button_continue != null, "Missing ui_button_continue in CheckpointUI.")
	ui_button_continue.connect("pressed", on_continue_pressed)
	ui_button_sell = get_node("%Sell")
	assert(ui_button_sell != null, "Missing ui_button_sell in CheckpointUI.")
	ui_label_title = get_node("%Title")
	assert(ui_label_title != null, "Missing ui_label_title in CheckpointUI.")

func on_continue_pressed():
	AudioPlayer.play_sound(preload("res://assets/audio/voice_defend_the_cargo_captain.wav"))
	emit_signal("continue_pressed")

func open(title: String):
	ui_label_title.text = title
	ui_root.visible = true
	ui_button_continue.grab_focus()

func close():
	ui_root.visible = false
