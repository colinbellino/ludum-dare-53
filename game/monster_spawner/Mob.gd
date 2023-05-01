class_name Mob extends RigidBody2D

@export var projectile : PackedScene
@export var damage : float = 1.0
@export var spread : float = 1.0

@export var hitpoints = 10.0
@export var speed = 200
@export var scroll_speed = 10
@export var approach_distance = 50
@export var attack_distance = 200
@export var accleration = 1.0
@export var movement_type : MovementTypes
@export var attack_type : AttackTypes
@export var attack_cooldown : float = 1
var direction_established : bool

enum MovementTypes { Stationary, HorizontalLine, TowardsShip }
enum AttackTypes { Ranged, Collision, Touch, Bomb }

var target_position = Vector2(0, 0)
var target_velocity = Vector2(0, 0)
var side_of_ship = -1

func _physics_process(_delta):
	if not GameData.level:
		return

	match movement_type:
		MovementTypes.Stationary:
			target_velocity.y = -GameData.level.ship.velocity.y

		MovementTypes.HorizontalLine:
			if direction_established == false:
				target_velocity = (GameData.level.ship.global_position - global_position).normalized() * speed * randi_range(-4,4)
				direction_established = true

		MovementTypes.TowardsShip:
			side_of_ship = signf(global_position.x - GameData.level.ship.global_position.x)
			target_position.x = GameData.level.ship.global_position.x + approach_distance * side_of_ship
			target_position.y = clamp(global_position.y, GameData.level.ship.global_position.y-100.0, GameData.level.ship.global_position.y+100.0)
			target_velocity = (target_position - global_position).normalized() * speed

	if global_position.distance_to(GameData.level.ship.global_position) < attack_distance and attack_type == AttackTypes.Ranged:
		ranged_attack()

	if abs(target_velocity.x) > 150.0 && has_node("Pivot"):
		$Pivot.scale.x = signf(target_velocity.x)

func _integrate_forces(state):
	state.set_constant_force((target_velocity - state.linear_velocity).limit_length(accleration * speed))
	queue_redraw()

func _draw():
	draw_rect(Rect2(target_position - global_position, Vector2(4, 4)), Color.RED)

func _on_visible_on_screen_notifier_2d_screen_exited(): # Removes enemies that go off screen
	queue_free()

func ranged_attack():
	if has_node("AttackTimer") == false:
		return

	if $AttackTimer.is_stopped():
		var p = projectile.instantiate()
		get_parent().add_child(p)
		p.global_position = %BulletSpawnPosition.global_position
		p.bullet_damage = damage
		p.rotation = 0.0 if $Pivot.scale.x > 0 else PI
		p.rotation_degrees += randf_range(-spread,spread)
		$AttackTimer.start()

func take_hit(damage: float):
	hitpoints -= damage
	if hitpoints <= 0:
		queue_free()
		#Play some animation or emit particles for destroying it

func _on_attack_area_body_entered(body):
	if attack_type == AttackTypes.Collision:
		if body.has_method("take_hit"):
			body.take_hit(damage)
			queue_free()
	if $AttackTimer.is_stopped() and attack_type == AttackTypes.Touch:
		if body.has_method("take_hit") and not body.is_in_group("Monsters"):
			body.take_hit(damage)
			$AttackTimer.start()
