class_name WorldMapNode

var name: String
var position: Vector2
var color: Color
var children: Array[WorldMapNode]
var parents: Array[WorldMapNode]
var size: float
var wave_template: WaveTemplate = Res.WAVE_TEMPLATE_0
var difficulty: float = 1.0
var length: float = 60.0
var checkpoint_wave: Wave = Res.WAVE_CHECKPOINT_0
