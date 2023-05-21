class_name GameOverUI extends CanvasLayer

var button_close : Button
var control_root : Control
var control_content : Control

func _ready():
	AudioPlayer.play_music(preload("res://assets/audio/gameover.ogg"), false)

	button_close = get_node("%Close")
	button_close.connect("pressed", on_close_pressed)
	control_root = get_node("%Root")
	control_root.modulate = Color.TRANSPARENT
	control_content = get_node("%Content")
	control_content.modulate = Color.TRANSPARENT

	var tween := create_tween()
	tween.tween_property(control_root, "modulate", Color.WHITE, 1.0)
	await tween.finished

	await get_tree().create_timer(5).timeout
	AudioPlayer.play_sound(preload("res://assets/audio/voice_total_destruction.wav"))

	tween = create_tween()
	tween.tween_property(control_content, "modulate", Color.WHITE, 1.0)
	await tween.finished

func close() -> void:
	var tween := create_tween()
	tween.tween_property(control_content, "modulate", Color.TRANSPARENT, 1.0)
	await tween.finished

	queue_free()

func on_close_pressed():
	Overlay.transition("res://game/level/Level.tscn")
