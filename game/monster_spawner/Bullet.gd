extends Area2D

@export var speed : int = 1000;

var bullet_damage : int;

func _physics_process(delta) -> void:
	position += Vector2(1.0, 0.0).rotated(rotation) * speed * delta

func _on_body_entered(body) -> void:
	if body.has_method("take_hit"):
		body.take_hit(bullet_damage)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
