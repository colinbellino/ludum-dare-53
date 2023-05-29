class_name DamagingExplosion extends Area2D

@export var radius : float = 16.0
@export var damage : float = 10.0
@export var knockback : float = 20.0
@export var damage_frame : int = 3

var anim : AnimatedSprite2D

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	scale *= radius / 16.0

	anim = get_node("%Anim")
	anim.play("default")
	anim.connect("frame_changed", self.on_frame_changed)

	await anim.animation_finished
	queue_free()

func on_frame_changed() -> void:
	if anim.frame == damage_frame:
		_apply_damage()

func _apply_damage() -> void:
	for body in get_overlapping_bodies():
		var hit_direction = global_position.direction_to(body.global_position)
		if body.has_method("take_hit"):
			body.take_hit(damage)
		if body is RigidBody2D:
			body.apply_impulse(hit_direction * knockback)
