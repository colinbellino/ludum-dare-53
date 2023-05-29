class_name CheckpointUI extends Node

var cargo_text_default : String
var text_cargo_shipped : RichTextLabel
var text_cargo_req : RichTextLabel
var text_cargo_worth : RichTextLabel
var button_continue : Button
var label_title : Label
var templates : Dictionary = {}

signal continue_pressed()

func _ready() -> void:
	button_continue = get_node("%Continue")
	button_continue.grab_focus()

	label_title = get_node("%Title")
	label_title.text = "Alpha Centauri #" + str(GameData.level.checkpoint_index)

	text_cargo_shipped = get_node("%cargo_shipped")
	text_cargo_shipped.text = tr(text_cargo_shipped.text) % [GameData.level.last_checkpoint_cargo_worth]

	text_cargo_req = get_node("%cargo_req")
	text_cargo_req.text = tr(text_cargo_req.text) % [GameData.CARGO_REQUIRED]

	text_cargo_worth = get_node("%cargo_worth")
	cargo_text_default = text_cargo_worth.text

func _process(_delta: float) -> void:
	text_cargo_worth.text = tr(cargo_text_default) % [GameData.level.cargo_worth(), GameData.level.calc_difficulty_multiplier()*100.0]

func set_text(node: RichTextLabel, values: Array) -> void:
	if not templates.has(node):
		templates[node] = node.text
	node.text = templates[node] % values

func on_continue_pressed() -> void:
	if GameData.level.cargo_worth() < GameData.CARGO_REQUIRED:
		AudioPlayer.play_ui_error_sound()
	else:
		queue_free()
