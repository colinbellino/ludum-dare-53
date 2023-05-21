extends Area2D

@export var radius = 16.0
@export var damage = 10.0
@export var knockback = 20.0

var anim : AnimatedSprite2D

func _ready() -> void:
	anim = get_node("%Anim")
	scale *= radius / 16.0
	anim.play("default")
	anim.connect("frame_changed", self.on_frame_changed)
	anim.connect("animation_finished", self.queue_free)

func on_frame_changed() -> void:
	if anim.frame == 3:
		apply_damage()

func apply_damage() -> void:
	for body in get_overlapping_bodies():
		var hit_direction = global_position.direction_to(body.global_position)
		if body.has_method("take_hit"):
			body.take_hit(damage)
		if body is RigidBody2D:
			body.apply_impulse(hit_direction * knockback)
