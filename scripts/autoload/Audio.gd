extends Node

var bus_main : int
var bus_music : int
var bus_sound : int
var audio_player_sound : AudioStreamPlayer2D
var audio_player_music : AudioStreamPlayer2D

func _ready():
	bus_main = AudioServer.get_bus_index("Master")
	assert(bus_main != null, "bus_main not initialized correctly.")
	bus_music = AudioServer.get_bus_index("Music")
	assert(bus_music != null, "bus_music not initialized correctly.")
	bus_sound = AudioServer.get_bus_index("Sound")
	assert(bus_sound != null, "bus_sound not initialized correctly.")
	audio_player_music = get_node("%MusicPlayer")
	assert(audio_player_music != null, "audio_player_music not initialized correctly.")
	audio_player_sound = get_node("%SoundPlayer")
	assert(audio_player_sound != null, "audio_player_sound not initialized correctly.")

	# FIXME: still a work in progress

func play_sound(stream: AudioStream, position: Vector2 = Vector2(120, 72), loop: bool = false, pitch_scale : float = 1.0) -> void:
	stream.loop = loop

	var player := spawn_audio_player()
	player.position = position
	player.pitch_scale = pitch_scale
	player.stream = stream
	player.play()

func play_sound_random(streams: Array[AudioStream], position: Vector2 = Vector2(120, 72), loop: bool = false) -> void:
	var index := randi() % streams.size()
	var stream := streams[index]
	play_sound(stream, position, loop)

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

func spawn_audio_player() -> AudioStreamPlayer:
	# FIXME: i don't know how we can to do this with this workflow
	return null
