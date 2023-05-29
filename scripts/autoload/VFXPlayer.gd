extends Node

func spawn_fx(fx_scene: PackedScene, position: Vector2, parent: Node = self) -> Node2D:
	var fx = fx_scene.instantiate()
	fx.position = position
	parent.add_child(fx)
	return fx
