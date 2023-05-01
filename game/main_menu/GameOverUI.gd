class_name GameOverUI extends CanvasLayer

func _ready():
	%Close.connect("pressed", on_close_pressed)

	%Root.modulate = Color.TRANSPARENT
	%Content.modulate = Color.TRANSPARENT

	var tween := create_tween()
	tween.tween_property(%Root, "modulate", Color.WHITE, 1.0)
	await tween.finished

	tween = create_tween()
	tween.tween_property(%Content, "modulate", Color.WHITE, 1.0)
	await tween.finished

func close() -> void:
	var tween := create_tween()
	tween.tween_property(%Content, "modulate", Color.TRANSPARENT, 1.0)
	await tween.finished

	queue_free()

func on_close_pressed():
	AudioPlayer.play_ui_button_sound()

	Overlay.transition("res://game/level/Level.tscn")
