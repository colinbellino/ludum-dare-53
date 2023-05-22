class_name Explosion extends AnimatedSprite2D

func _ready() -> void:
	play("default")
	await self.animation_finished
	queue_free()
