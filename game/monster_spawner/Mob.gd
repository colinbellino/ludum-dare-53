class_name Mob extends RigidBody2D

@export var damage : float = 1.0
@export var spread : float = 1.0
@export var hitpoints = 10.0
@export var speed = 200
@export var approach_distance = 50
@export var attack_distance = 200
@export var accleration = 1.0
@export var movement_type : MovementTypes
@export var attack_type : AttackTypes
@export var projectile_sprite : Texture
@export var projectile_speed = 200.0

var shot_cooldown = 0.0
var direction_established : bool
var current_target = null
var target_position = Vector2(0, 0)
var target_velocity = Vector2(0, 0)
var target_rotation = 0.0
var current_rotation = 0.0
var side_of_ship = -1
var pivot : Node2D
var bullet_spawn_position : Marker2D

enum MovementTypes { Stationary, HorizontalLine, TowardsShip }
enum AttackTypes { Ranged, Collision, Touch, Bomb }

func _ready() -> void:
	pivot = get_node_or_null("Pivot")
	bullet_spawn_position = get_node("%BulletSpawnPosition")

func _physics_process(delta):
	if not GameData.level:
		return

	match movement_type:
		MovementTypes.HorizontalLine:
			if direction_established == false:
				target_velocity = (GameData.level.ship.global_position - global_position).normalized() * speed
				direction_established = true

		MovementTypes.TowardsShip:
			side_of_ship = signf(global_position.x - GameData.level.ship.global_position.x)
			target_position.x = GameData.level.ship.global_position.x + approach_distance * side_of_ship
			target_position.y = clamp(global_position.y, GameData.level.ship.global_position.y-100.0, GameData.level.ship.global_position.y+100.0)
			target_velocity = (target_position - global_position).normalized() * speed
	if attack_type == AttackTypes.Ranged:
		if global_position.distance_to(GameData.level.ship.global_position) < attack_distance and attack_type == AttackTypes.Ranged:
			if shot_cooldown > 0.0:
				shot_cooldown -= delta
			if shot_cooldown <= 0.0 and abs(Utils.angle_difference(target_rotation, current_rotation)) < PI/6:
				spawn_bullet()
				shot_cooldown = 1.0

	if abs(target_velocity.x) > 150.0 && pivot != null:
		pivot.scale.x = signf(target_velocity.x)

func _integrate_forces(state):
	state.set_constant_force((target_velocity - state.linear_velocity).limit_length(accleration * speed))
	queue_redraw()

# Removes enemies that go off screen
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func spawn_bullet():
	var level = GameData.level
	var bullet = preload("res://game/bullet/Bullet.tscn").instantiate()
	bullet.sprite = projectile_sprite
	bullet.speed = projectile_speed
	bullet.damage = damage
	bullet.direction = Vector2.ZERO.direction_to(bullet_spawn_position.position).rotated(current_rotation)
	level.add_child(bullet)
	bullet.global_position = bullet_spawn_position.global_position

func take_hit(hit: int):
	hitpoints -= hit
	if hitpoints <= 0:
		queue_free()
		# TODO: Play some animation or emit particles for destroying it

func _on_attack_area_body_entered(body):
	if attack_type == AttackTypes.Collision:
		if body.has_method("take_hit"):
			body.take_hit(damage)
			queue_free()
	if shot_cooldown <= 0.0 and attack_type == AttackTypes.Touch:
		if body.has_method("take_hit") and not body.is_in_group("Monsters"):
			# No idea where we would reach this atm?
			breakpoint
			# body.take_hit(damage)
			# $AttackTimer.start()

func aquire_target():
	var ship_part = get_tree().get_nodes_in_group("ShipParts")
	ship_part = ship_part.filter(is_valid_target)
	ship_part.sort_custom(
		func(a,b):
			return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position)
	)
	if ship_part.size() > 0:
		if ship_part[0].global_position.distance_to(global_position) < attack_distance:
			current_target = ship_part[0]

func is_valid_target(ship_part):
	return (
		is_instance_valid(ship_part)
		&& ship_part.hitpoints > 0
	)
