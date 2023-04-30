class_name Checkpoint extends Sprite2D

var area : Area2D
var was_reached : bool

signal reached()

func _ready():
	area = get_node("%Area2D")
	area.connect("area_entered", on_area_entered)

func on_area_entered(other: Area2D):
	if was_reached == false && other.get_parent().name == "Ship":
		emit_signal("reached")
		was_reached = true
