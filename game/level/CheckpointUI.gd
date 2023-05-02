class_name CheckpointUI extends Control

signal continue_pressed()

var cargo_text : String

func _ready():
	%Continue.grab_focus()
	var level = GameData.level
	%Title.text = "Alpha Centauri #" + str(level.checkpoint_index)
	%cargo_shipped.text = tr(%cargo_shipped.text) % [level.last_checkpoint_cargo_worth]
	%cargo_req.text = tr(%cargo_req.text) % [level.cargo_required]
	cargo_text = %cargo_worth.text

var templates = {}

func set_text(node:RichTextLabel, values:Array):
	if not templates.has(node):
		templates[node] = node.text
	node.text = templates[node] % values

func _process(delta):
	%cargo_worth.text = tr(cargo_text) % [GameData.level.cargo_worth(), GameData.level.calc_difficulty_multiplier()*100.0]

func on_continue_pressed():
	if GameData.level.cargo_worth() < GameData.level.cargo_required:
		AudioPlayer.play_ui_error_sound()
	else:
		queue_free()
