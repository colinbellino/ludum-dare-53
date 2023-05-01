class_name CheckpointUI extends Control

signal continue_pressed()

func _ready():
	%Continue.grab_focus()
	var level = GameData.level
	%Title.text = "Alpha Centauri #" + str(level.checkpoint_index)
	set_text(%cargo_shipped, [level.last_checkpoint_cargo_worth])
	set_text(%cargo_req, [level.cargo_required])
	
var templates = {}

func set_text(node:RichTextLabel, values:Array):
	if not templates.has(node):
		templates[node] = node.text
	node.text = templates[node] % values

func _process(delta):
	set_text(%cargo_worth, [GameData.level.cargo_worth(), GameData.level.calc_difficulty_multiplier()*100.0])

func on_continue_pressed():
	if GameData.level.cargo_worth() < GameData.level.cargo_required:
		AudioPlayer.play_ui_error_sound()
	else:
		AudioPlayer.play_ui_button_sound()
		queue_free()
