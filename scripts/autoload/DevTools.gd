extends Control

func _process(_delta: float) -> void:
	if OS.is_debug_build():
		if Input.is_action_just_released("debug_1"):
			GameData.money += 1000
			AudioPlayer.play_ui_money_sound()

		if Input.is_action_just_released("debug_11"):
			GameData.cheat_skip_checkpoint = !GameData.cheat_skip_checkpoint

		if Input.is_action_just_released("debug_12"):
			GameData.cheat_invincible = !GameData.cheat_invincible

		if Input.is_key_pressed(KEY_SHIFT):
			Engine.set_time_scale(20)
		else:
			Engine.set_time_scale(1)
