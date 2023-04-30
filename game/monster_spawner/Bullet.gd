extends Area2D

var bullet_damage;
@export var speed = 1000;

func _physics_process(delta):
	position += Vector2(1.0, 0.0).rotated(rotation) * speed * delta

func _on_body_entered(body):
	if body.has_method("take_hit"):
		body.take_hit(bullet_damage)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
