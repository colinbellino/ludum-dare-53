class_name Cargo extends BaseTurret

@export var delievery_value = 200
@export var attract_danger := 0.0

func destroyed() -> void:
	# FIXME: remove this, it's just to debug destroyed cargo
	(get_node("Base") as Sprite2D).modulate.a = 0.5
	Game.level.on_cargo_destroyed(self)
