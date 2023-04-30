class_name Mob extends RigidBody2D

@export var speed = 200
@export var scroll_speed = 10
@export var approach_distance = 100
@export var movement_type : MovementTypes
var direction_established : bool
var sprite : Sprite2D
var collision_shape : CollisionShape2D

enum MovementTypes { Stationary, HorizontalLine, TowardsShip }

func _ready():
	sprite = get_node("Sprite")
	assert(sprite != null, "sprite not found in Mob.")

	collision_shape = get_node("CollisionShape2D")
	assert(collision_shape != null, "collision_shape not found in Mob.")

func _process(_delta):
	if GameData.level:
		# FIXME: this is placeholder code for movement, it's absolutely not doing what it should
		match movement_type:
			MovementTypes.Stationary:
				linear_velocity.y = -GameData.level.ship.linear_velocity.y
				pass

			MovementTypes.HorizontalLine:
				if direction_established == false:
					linear_velocity.x = (GameData.level.ship.position - position).normalized().x * speed
					direction_established = true

			MovementTypes.TowardsShip:
				linear_velocity.x = (GameData.level.ship.position - position).normalized().x * speed
				# # Stops approaching at defined distances to the center
				# if position.x > 480-approach_distance and position.x < 480+approach_distance:
				# 	linear_velocity.x = 0

func _on_visible_on_screen_notifier_2d_screen_exited(): # Removes enemies that go off screen
	queue_free()
