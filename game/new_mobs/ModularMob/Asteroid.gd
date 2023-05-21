extends RigidBody2D

@export var collision_damage : int = 10
@export var collision_self_damage : int = 5
@export var collision_discriminate_enemies : bool = false
@export var collision_cooldown : float = 0.5
@export var hitpoints : int = 15
@export var launch_speed_min : int = 400
@export var launch_speed_max : int = 800
@export var launch_direction_randomness : int = 200

var initialized : bool = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	# Removes enemies that go off screen
	queue_free()

func _physics_process(_delta: float) -> void:
	if !initialized:
		var target_position = GameData.level.ship.global_position + Vector2(randf_range(-launch_direction_randomness, launch_direction_randomness), randf_range(-launch_direction_randomness, launch_direction_randomness))
		linear_velocity = global_position.direction_to(target_position) * randf_range(launch_speed_min, launch_speed_max)
		initialized = true

	if contact_monitor:
		for body in get_colliding_bodies():
			var apply_damage = true
			if collision_discriminate_enemies:
				apply_damage = body.collision_layer & GameData.PHYSICS_LAYER_SHIP_HURTABLE

			if body.has_method("take_hit") and apply_damage:
				body.take_hit(collision_damage)
				self.take_hit(collision_self_damage)
				contact_monitor = false
				get_tree().create_timer(collision_cooldown, false, true).timeout.connect(
					func():
						contact_monitor = true
				)

func take_hit(hit: int) -> void:
	hitpoints -= hit
	if hitpoints <= 0:
		queue_free()
