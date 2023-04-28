extends CanvasLayer

signal closed

func ui_mappings():
	return {
		%Fullscreen : "window_fullscreen",
		%VolumeMain : "volume_main",
		%VolumeMusic : "volume_music",
		%VolumeSound : "volume_sound"
	}

func _ready() -> void:
	%Fullscreen.visible = Settings.can_fullscreen()
	Utils.sync_to_ui(ui_mappings(), Settings)
	%Fullscreen.grab_focus()

func close():
	Utils.sync_from_ui(ui_mappings(), Settings)
	Settings.save_all()
	queue_free()
