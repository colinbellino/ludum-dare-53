class_name GameOverUI extends CanvasLayer

func _ready():
	AudioPlayer.play_music(preload("res://assets/audio/gameover.ogg"), false)

	%Close.connect("pressed", on_close_pressed)

	%Root.modulate = Color.TRANSPARENT
	%Content.modulate = Color.TRANSPARENT

	var tween := create_tween()
	tween.tween_property(%Root, "modulate", Color.WHITE, 1.0)
	await tween.finished

	await get_tree().create_timer(5).timeout
	AudioPlayer.play_sound(preload("res://assets/audio/voice_total_destruction.wav"))

	tween = create_tween()
	tween.tween_property(%Content, "modulate", Color.WHITE, 1.0)
	await tween.finished

func close() -> void:
	var tween := create_tween()
	tween.tween_property(%Content, "modulate", Color.TRANSPARENT, 1.0)
	await tween.finished

	queue_free()

func on_close_pressed():
	Overlay.transition("res://game/level/Level.tscn")
