extends StaticBody2D

var trigger_area: Area2D

var acceleration : float = 1.0

func _ready() -> void:
	trigger_area = get_node("%CheckpointArea")
	trigger_area.connect("area_entered", on_area_entered)
	GameData.level.connect("checkpoint_reached", on_checkpoint_reached)
	GameData.level.connect("checkpoint_departed", on_checkpoint_departed)

func _process(delta: float) -> void:
	position += Vector2(0, 50) * delta * acceleration

func on_area_entered(area: Area2D) -> void:
	if area.get_owner() == GameData.level.ship:
		print("trigger_checkpoint_reached")
		GameData.level.trigger_checkpoint_reached()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func on_checkpoint_reached() -> void:
	var tween := create_tween().tween_property(self, "acceleration", 0.0, 1.0)

func on_checkpoint_departed() -> void:
	var tween := create_tween().tween_property(self, "acceleration", 1.0, 2.0)
