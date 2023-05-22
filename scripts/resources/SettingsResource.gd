class_name SettingsResource extends Resource

@export var window_fullscreen : bool
@export var resolution : Vector2
@export var volume_main : float = 0.7
@export var volume_music : float = 0.7
@export var volume_sound : float = 1.0
@export var locale : String = "en"
@export var level : String = "Level"

func _init() -> void:
	if Settings.can_fullscreen():
		resolution = Vector2(1920, 1080)
	else:
		resolution = Vector2(960, 540)
