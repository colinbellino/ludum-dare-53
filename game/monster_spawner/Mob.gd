class_name Mob extends RigidBody2D

@export var projectile : PackedScene
@export var damage : float = 1.0
@export var spread : float = 1.0

@export var hitpoints = 10.0
@export var speed = 200
@export var scroll_speed = 10
@export var approach_distance = 50
@export var movement_type : MovementTypes
@export var attack_type : AttackTypes
@export var attack_cooldown : float = 1
var direction_established : bool
var sprite : Sprite2D
var collision_shape : CollisionShape2D

enum MovementTypes { Stationary, HorizontalLine, TowardsShip }
enum AttackTypes { Ranged, Collision, Touch }

func _ready():
	sprite = get_node("Sprite")
	assert(sprite != null, "sprite not found in Mob.")

	collision_shape = get_node("CollisionShape2D")
	assert(collision_shape != null, "collision_shape not found in Mob.")

func _process(_delta):
	linear_velocity.y = -GameData.level.ship.linear_velocity.y

	if GameData.level:
		match movement_type:
			MovementTypes.Stationary:
				pass

			MovementTypes.HorizontalLine:
				if direction_established == false:
					linear_velocity.x = (GameData.level.ship.position - position).normalized().x * speed
					direction_established = true

			MovementTypes.TowardsShip:
				linear_velocity.x = (GameData.level.ship.position - position).normalized().x * speed
				# # Stops approaching at defined distances to the center
#				if position.x > 480-approach_distance and position.x < 480+approach_distance:
#					linear_velocity.x = 0
#					attack()

func _on_visible_on_screen_notifier_2d_screen_exited(): # Removes enemies that go off screen
	queue_free()

func attack():
	if $AttackTimer.is_stopped():
		match attack_type:
			AttackTypes.Touch:
				$AttackTimer.start()
				pass
			AttackTypes.Ranged:
				var p = projectile.instantiate()
				add_child(p)
				p.damage = damage
				p.transform = (GameData.level.ship.position - position).normalized()
				p.rotation_degrees += randf_range(-spread,spread)
				$AttackTimer.start()
			AttackTypes.Collision:
				pass

func take_hit(damage: float):
	hitpoints -= damage
	if hitpoints <= 0:
		queue_free()
		#Play some animation or emit particles for destroying it
