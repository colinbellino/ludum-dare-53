extends Node

func _ready():
	pass

func spawn_fx(fx_scene: PackedScene, position: Vector2) -> Node2D:
	var fx = fx_scene.instantiate()
	fx.position = position
	self.add_child(fx)
	return fx
