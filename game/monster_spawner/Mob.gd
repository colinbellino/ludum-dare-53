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
var sprite : Sprite2D
var collision_shape : CollisionShape2D

enum MovementTypes { Stationary, HorizontalLine, TowardsShip }
enum AttackTypes { Ranged, Collision, Touch, Bomb }

func _ready():
	sprite = get_node("Sprite")
	assert(sprite != null, "sprite not found in Mob.")

	collision_shape = get_node("CollisionShape2D")
	assert(collision_shape != null, "collision_shape not found in Mob.")

var target_position = Vector2(0, 0)
var target_velocity = Vector2(0, 0)
var side_of_ship = -1

func _process(_delta):
	if not GameData.level:
		return
		
	match movement_type:
		MovementTypes.Stationary:
			pass

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

	apply_impulse((target_velocity - linear_velocity) * _delta * accleration)
	#if abs(target_velocity.x) > 25.0:
	#	scale.x = signf(target_velocity.x)
	queue_redraw()
	
func _draw():
	draw_rect(Rect2(target_position - global_position, Vector2(4, 4)), Color.RED)

func _on_visible_on_screen_notifier_2d_screen_exited(): # Removes enemies that go off screen
	queue_free()

func ranged_attack():
	if $AttackTimer.is_stopped():
		var p = projectile.instantiate()
		add_child(p)
		p.bullet_damage = damage
		#p.transform = (GameData.level.ship.global_position - global_position).normalized() # Passing direction incorrectly
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
