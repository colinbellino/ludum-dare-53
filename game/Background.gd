extends ParallaxBackground

var parallax_bg : ParallaxBackground

const SPEED : int = 30

func _ready() -> void:
	parallax_bg = get_node("%BG")

func _process(delta: float) -> void:
	parallax_bg.scroll_base_offset += parallax_bg.scroll_base_scale * delta * GameData.level.ship.movement_mult * SPEED
