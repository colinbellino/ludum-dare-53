extends AudioStreamPlayer2D

func on_finished():
	queue_free()
