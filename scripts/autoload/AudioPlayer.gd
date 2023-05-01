extends Node2D

var bus_main : int
var bus_music : int
var bus_sound : int
var audio_player_sound_one_shot : AudioStreamPlayer2D
var audio_player_sound : AudioStreamPlayer2D
var audio_player_music : AudioStreamPlayer2D

func _ready():
	bus_main = AudioServer.get_bus_index("Master")
	assert(bus_main != null, "bus_main not initialized correctly.")
	bus_music = AudioServer.get_bus_index("Music")
	assert(bus_music != null, "bus_music not initialized correctly.")
	audio_player_sound_one_shot = get_node("%SoundPlayerOneShot")
	assert(audio_player_sound_one_shot != null, "audio_player_sound_one_shot not initialized correctly.")
	bus_sound = AudioServer.get_bus_index("Sound")
	assert(bus_sound != null, "bus_sound not initialized correctly.")
	audio_player_music = get_node("%MusicPlayer")
	assert(audio_player_music != null, "audio_player_music not initialized correctly.")
	audio_player_sound = get_node("%SoundPlayer")
	assert(audio_player_sound != null, "audio_player_sound not initialized correctly.")

func _process(_delta):
	if GameData.level && GameData.level.ship:
		self.global_position = GameData.level.ship.global_position

		audio_player_music.pitch_scale = Engine.get_time_scale()

func play_sound(stream: AudioStream, sound_position: Vector2 = get_viewport_rect().size / 2, loop: bool = false, pitch_scale : float = 1.0) -> void:
	if stream is AudioStreamWAV == false:
		stream.loop = loop

	var player := spawn_audio_player()
	player.position = position
	player.position = sound_position
	player.pitch_scale = pitch_scale
	player.stream = stream
	player.play()

func play_sound_random(streams: Array, sound_position: Vector2, loop: bool = false) -> void:
	if streams.size() == 0:
		return
	var index := randi() % streams.size()
	var stream = streams[index]
	play_sound(stream, sound_position, loop, randf_range(0.8, 1.2))

func play_music(stream: AudioStream, loop: bool = true) -> void:
	stream.set_loop(loop)

	audio_player_music.stream = stream
	if audio_player_music.playing:
		audio_player_music.stop()
	audio_player_music.stream = stream
	audio_player_music.pitch_scale = Engine.time_scale
	audio_player_music.play()

func stop_music() -> void:
	audio_player_music.stop()

func spawn_audio_player() -> AudioStreamPlayer2D:
	var audio_player = audio_player_sound_one_shot.duplicate()
	if Engine.time_scale > 0:
		audio_player.pitch_scale = Engine.time_scale
	self.add_child(audio_player)
	return audio_player

func play_ui_hover_sound() -> void:
	play_sound(preload("res://assets/audio/button_hover.wav"), position);

func play_ui_button_sound() -> void:
	play_sound(preload("res://assets/audio/button_click.wav"), position);

func play_ui_error_sound() -> void:
	play_sound(preload("res://assets/audio/error.wav"), position);

func play_ui_money_sound() -> void:
	play_sound(preload("res://assets/audio/money.wav"), position);

func play_ui_repair_sound() -> void:
	play_sound(preload("res://assets/audio/repair.wav"), position);
