class_name NewMob extends RigidBody2D

@export var collision_damage := 10
@export var collision_self_damage := 5
@export var collision_discriminate_enemies := true
@export var collision_cooldown = 0.5

@export var hitpoints = 10.0
@export var speed = 200
@export var approach_distance = 50
@export var approach_distance_occilation_period = 1.0
@export var approach_distance_occilation_amplitude = 0.0
@export var accleration = 1.0
@export var movement_type : MovementTypes
@export var movement_type_when_in_range : MovementTypes

var shot_cooldown = 0.0
var occilation_timer = 0.0
var direction_established : bool

enum MovementTypes { TowardsShip, CircleShip }

var current_target = null
var target_position = Vector2(0, 0)
var target_velocity = Vector2(0, 0)
var target_rotation = 0.0
var current_rotation = 0.0
var side_of_ship = -1

func _physics_process(delta):
	if not GameData.level:
		return

	var ship_position = GameData.level.ship.global_position
	var ship_velocity = GameData.level.ship.linear_velocity
	var distance_to_target = global_position.distance_to(target_position)

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

	if distance_to_target < approach_distance:
		movement_type = movement_type_when_in_range
		occilation_timer += delta

	var target_distance = approach_distance + sin(occilation_timer * PI / approach_distance_occilation_period) * approach_distance_occilation_amplitude
	match movement_type:
		MovementTypes.TowardsShip:
			side_of_ship = signf(global_position.x - ship_position.x)
			target_position.x = ship_position.x + approach_distance * side_of_ship
			target_position.y = clamp(global_position.y, ship_position.y-100.0, ship_position.y+100.0)
		MovementTypes.CircleShip:
			var current_angle = (ship_position - global_position).normalized().angle()
			target_position = ship_position + Vector2.UP.rotated(current_angle + PI / 100) * target_distance
	target_velocity = (target_position - global_position).normalized() * speed + ship_velocity

	if abs(target_velocity.x) > 25.0 && has_node("Pivot"):
		$Pivot.scale.x = signf(target_velocity.x)

func _integrate_forces(state):
	state.set_constant_force((target_velocity - state.linear_velocity).limit_length(accleration * speed))

func _on_visible_on_screen_notifier_2d_screen_exited(): # Removes enemies that go off screen
	queue_free()

func take_hit(hit: float):
	hitpoints -= hit
	if hitpoints <= 0:
		queue_free()
		#Play some animation or emit particles for destroying it
