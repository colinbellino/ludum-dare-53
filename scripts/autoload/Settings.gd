extends Node

# TODO: Setters for these
@export var window_fullscreen : bool
@export var volume_main : float = 0.7
@export var volume_music : float = 0.7
@export var volume_sound : float = 0.7

func can_fullscreen():
	return OS.has_feature("pc")

func _ready():
	load_all()
	
func save_all():
	# TODO: Dump all properties with @export into a settings file.
	pass
	
func load_all():
	# TODO: Set all properties to the values found in the settings file.
	pass
