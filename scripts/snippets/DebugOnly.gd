extends Control

func _ready():
	if OS.has_feature("standalone"):
		visible = false
