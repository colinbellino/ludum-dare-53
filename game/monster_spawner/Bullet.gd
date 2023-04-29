extends Area2D

@export var bullet_damage = 20;
@export var speed = 1000;

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_body_entered(body):
	if body.has_method("get_hit"):
		body.get_hit(bullet_damage)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
