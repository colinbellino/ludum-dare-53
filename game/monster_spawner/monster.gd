extends RigidBody2D

@export var speed = 150
@export var scroll_speed = 10
@export var approach_distance = 200

func _process(delta):
	linear_velocity.y += scroll_speed * delta # Applies vertical acceleration
	# Stops approaching at defined distances to the center
	if position.x > 480-approach_distance and position.x < 480+approach_distance: linear_velocity.x = 0 

func _on_visible_on_screen_notifier_2d_screen_exited(): # Removes enemies that go off screen
	queue_free()
