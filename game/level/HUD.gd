extends Panel

func _process(_delta):
	if GameData.level:
		visible = true
		%Money.text = "Currency: %s" % [GameData.money]
		%Wave.text = "Wave: %s" % [GameData.level.wave_index]
	else:
		visible = false
