class_name PlayUI extends CanvasLayer

var container_control : Control
var label_name: LineEdit
var hunger_progress: TextureProgressBar
var settings_button: TextureButton
var feed_button: Button
var feed_sprite: Sprite2D
var next_feed : float
var mood_progress : TextureProgressBar
var mood_sprite : Sprite2D

func _ready() -> void:
	container_control = get_node("%Container")
	# label_name = get_node("%NameLabel")
	# hunger_progress = get_node("%HungerProgress")
	# settings_button = get_node("%SettingsButton")
	# feed_button = get_node("%FeedButton")
	# feed_sprite = get_node("%FeedSprite")
	# mood_progress = get_node("%MoodProgress")
	# mood_sprite = get_node("%MoodSprite")

	# label_name.connect("text_changed", self, "name_changed")
	# label_name.connect("focus_entered", self, "name_focus_entered")
	# label_name.connect("focus_exited", self, "name_focus_exited")
	# settings_button.connect("pressed", self, "settings_button_pressed")
	# settings_button.connect("mouse_entered", self, "button_mouse_entered")
	# settings_button.connect("mouse_exited", self, "button_mouse_exited")
	# feed_button.connect("pressed", self, "feed_button_pressed")
	# feed_button.connect("mouse_entered", self, "button_mouse_entered")
	# feed_button.connect("mouse_exited", self, "button_mouse_exited")

func open() -> void:
	visible = true

	var tween := container_control.create_tween()
	tween.tween_property(container_control, "position:y", 0.0, 0.3)
	await tween.finished

func close() -> void:
	var tween := container_control.create_tween()
	tween.tween_property(container_control, "position:y", -container_control.rect_size.y, 0.2)
	await tween.finished

	visible = false

func settings_button_pressed() -> void:
	Globals.ui_settings.open(true)
	Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])

func button_mouse_entered() -> void:
	Globals.set_cursor(Globals.CURSORS.HAND)

func button_mouse_exited() -> void:
	Globals.set_cursor(Globals.CURSORS.DEFAULT)

func name_changed(new_text: String) -> void:
	if new_text.length() == 0 || new_text.length() > 32:
		pass
	else:
		Globals.creature_name = new_text

func name_focus_entered() -> void:
	print("name_focus_entered: ", label_name.caret_position)
	label_name.set_cursor_position(label_name.text.length() - 1)

func name_focus_exited() -> void:
	pass
