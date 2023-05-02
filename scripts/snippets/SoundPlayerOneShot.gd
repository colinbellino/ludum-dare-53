extends AudioStreamPlayer

func on_finished():
	queue_free()
