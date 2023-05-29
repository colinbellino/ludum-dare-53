extends Node

var ship : Ship
var hud : HUD
var parallax_bg : ParallaxBackground
var level : Level
var checkpoint_ui : InstancePlaceholder

const CARGO_REQUIRED : int = 150

func _ready() -> void:
	checkpoint_ui = get_node("%CheckpointUI")
	parallax_bg = get_node("%BG")
	hud = get_node("%HUD")
	ship = get_node("%Ship")
	ship.find_child("ShipSlot3").build_structure(Res.TURRET_CARGO, true)
	ship.find_child("ShipSlot4").build_structure(Res.TURRET_CARGO, true)
