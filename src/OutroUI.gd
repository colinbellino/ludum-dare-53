class_name OutroUI extends CanvasLayer

var menu : Control
var quit_button : Button
var restart_button : Button
var message_label : Label

func _ready() -> void:
    menu = get_node("%Menu")
    quit_button = get_node("%Quit")
    restart_button = get_node("%Restart")
    message_label = get_node("%Message0")

    quit_button.connect("pressed", self, "button_quit_pressed")
    quit_button.connect("pressed", self, "play_button_sound")
    restart_button.connect("pressed", self, "button_restart_pressed")
    restart_button.connect("pressed", self, "play_button_sound")

    message_label.text = ""

func button_quit_pressed() -> void:
    Game.quit_game()

func button_restart_pressed() -> void:
    var tween := create_tween().set_parallel(true)
    tween.tween_property(menu, "modulate:a", 0.0, 0.5)
    tween.tween_property(message_label, "modulate:a", 0.0, 0.5)
    yield(tween, "finished")

    Globals.restart_game()

func play_button_sound(_whatever = null) -> void:
    Audio.play_sound_random([Globals.SFX.BUTTON_CLICK_2])

func open(cause: int) -> void:
    var message_label_text = tr("outro_%s" % [cause]) % [Globals.creature_name]
    message_label_text = message_label_text.strip_edges(true, true)
    message_label.text = ""
    for letter in message_label_text:
        message_label.text += letter
        Audio.play_sound(Globals.SFX.TEXT_TYPE)
        yield(get_tree().create_timer(Globals.LETTER_APPEAR_DELAY / 2), "timeout")
        Audio.play_sound(Globals.SFX.TEXT_TYPE)
        yield(get_tree().create_timer(Globals.LETTER_APPEAR_DELAY / 2), "timeout")

    yield(get_tree().create_timer(0.5), "timeout")

    menu.visible = true
    menu.modulate.a = 0.0
    var tween := create_tween()
    tween.tween_property(menu, "modulate:a", 1.0, 0.3)
    yield(tween, "finished")
