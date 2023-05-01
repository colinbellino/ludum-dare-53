extends Panel

func _process(_delta):
	%Money.text = str(GameData.money) + "$"
