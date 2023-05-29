class_name WorldMapUI extends Node

func _ready() -> void:
	# button_fullscreen = get_node("%Fullscreen")
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		Overlay.transition(Res.SCENE_LEVEL)
