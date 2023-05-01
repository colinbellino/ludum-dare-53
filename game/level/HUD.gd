extends Panel

func _process(_delta):
	if GameData.level:
		visible = true
		%Money.text = str(GameData.money) + "$"

		var progress := float(GameData.level.wave_index) / (GameData.level.waves.waves.size() -1)
		%LevelProgress.value = progress
	else:
		visible = false
