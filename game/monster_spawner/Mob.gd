class_name Mob
extends RigidBody2D

@export var speed = 200
@export var scroll_speed = 10
@export var approach_distance = 100
@export var movement_type : MovementTypes
var direction_established : bool

enum MovementTypes { HorizontalLine, TowardsCart }

func _process(delta):
	if GameData.level:
		linear_velocity.y += scroll_speed * delta # Applies vertical acceleration

		match movement_type:
			MovementTypes.HorizontalLine:
				if direction_established == false:
					linear_velocity.x = (GameData.level.cart.position - position).normalized().x * speed
					direction_established = true

			MovementTypes.TowardsCart:
				linear_velocity = (GameData.level.cart.position - position).normalized() * speed
				# Stops approaching at defined distances to the center
				if position.x > 480-approach_distance and position.x < 480+approach_distance:
					linear_velocity.x = 0


func _on_visible_on_screen_notifier_2d_screen_exited(): # Removes enemies that go off screen
	queue_free()
