extends Node

const MENU_MUSIC: AudioStreamMP3 = preload("res://assets/music/01 Sombras del Pasado.mp3")
const GAME_MUSIC: AudioStreamMP3 = preload("res://assets/music/04 Ecos en el Silencio.mp3")
const GAME_OVER_MUSIC: AudioStreamMP3 = preload("res://assets/music/10 Círculo de Sombras.mp3")
const CHASING_MUSIC: AudioStreamMP3 = preload("res://assets/music/02 Cacería Inminente.mp3")
const LETTER_MUSIC: AudioStreamMP3 = preload("res://assets/music/07 Pulso de lo Desconocido.mp3")
const CINEMATIC_MUSIC: AudioStreamMP3 = preload("res://assets/music/03 Ojos en la Noche.mp3")


const DOOR_OPEN_SOUND: AudioStream = preload("res://assets/audio/doorOpen_1.ogg")

@onready var music_player: AudioStreamPlayer = $Music.get_child(0) # There's only one music player
@onready var sound_players: Array = $Sound.get_children() # We can play multiple sounds at the same time


func play_music(music: AudioStreamMP3, pitch_scale: float = 1.0, volume_db: float = 0) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(music_player, "volume_db", -20, 1.00)
	await tween.finished
	music_player.stop()
	music_player.stream = music
	music_player.pitch_scale = pitch_scale
	music_player.volume_db = volume_db
	music_player.play()
	tween.tween_property(music_player, "volume_db", -5, 1.00)


func play_sound(sound: AudioStream) -> void:
	for player in sound_players:
		if not player.playing:
			player.stream = sound
			player.play()
			break
