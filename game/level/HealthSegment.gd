extends TextureRect

func _ready():
	set_material(get_material().duplicate())
	set_value(0)

func set_value(value: int) -> void:
	(material as ShaderMaterial).set_shader_parameter("mask_offset", Vector2i(clamp(value, 0, 4), 0))
