extends Panel

func _process(_delta):
	if GameData.level:
		%Money.text = tr("Currency: %d") % [GameData.money]
		%Wave.text = "Wave: %s" % [GameData.level.wave_index]
