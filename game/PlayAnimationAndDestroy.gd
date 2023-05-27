class_name PlayAnimationAndDestroy extends AnimatedSprite2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	play(animation)
	await self.animation_finished
	queue_free()
