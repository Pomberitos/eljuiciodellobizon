extends Node

const MENU_MUSIC: AudioStreamMP3 = preload("res://assets/music/_15 Susurros Perdidos.mp3")
const GAME_MUSIC: AudioStreamMP3 = preload("res://assets/music/04 Ecos en el Silencio.mp3")
const GAME_OVER_MUSIC: AudioStreamMP3 = preload("res://assets/music/10 Círculo de Sombras.mp3")
const CHASING_MUSIC: AudioStreamMP3 = preload("res://assets/music/02 Cacería Inminente.mp3")
const LETTER_MUSIC: AudioStreamMP3 = preload("res://assets/music/_07 Pulso de lo Desconocido loop.mp3")
#const CINEMATIC_MUSIC: AudioStreamMP3 = preload("res://assets/music/_12 Laberinto Interior Parte 2.mp3")
const CINEMATIC_MUSIC: AudioStreamMP3 = preload("res://assets/music/_15 Susurros Perdidos.mp3")
const LOBIZON_APPROACHING: AudioStreamMP3 = preload("res://assets/music/intro_lobizón_1.mp3")


const DOOR_OPEN_SOUND: AudioStream = preload("res://assets/audio/doorOpen_1.ogg")
const LOBIZON_HOWLING: AudioStreamOggVorbis = preload("res://assets/audio/wolf.ogg")
const THUNDER_SOUND: AudioStreamWAV = preload("res://assets/audio/trueno.wav")
const LAUGH_SOUND: AudioStreamOggVorbis = preload("res://assets/audio/Freesound - Insane girl laughter by MadamVicious.ogg")
const LOBIZON_SNARL: AudioStreamWAV = preload("res://assets/audio/wolf_snarl.wav")
const PAGE_FLIP: AudioStreamOggVorbis = preload("res://assets/audio/bookFlip1.ogg")
const TEXTO_1: AudioStreamOggVorbis = preload("res://assets/audio/text_audio1.ogg")
const TEXTO_2: AudioStreamOggVorbis = preload("res://assets/audio/text_audio2.ogg")
const TEXTO_3: AudioStreamOggVorbis = preload("res://assets/audio/text_audio3.ogg")
const TEXTO_4: AudioStreamOggVorbis = preload("res://assets/audio/text_audio4.ogg")


@onready var music_player: AudioStreamPlayer = $Music.get_child(0) # There's only one music player
@onready var sound_players: Array = $Sound.get_children() # We can play multiple sounds at the same time


func play_music(music: AudioStream, pitch_scale: float = 1.0, volume_db: float = 0) -> void:
	if music_player.stream == music:
		return
	var tween = get_tree().create_tween()
	tween.tween_property(music_player, "volume_db", -20, 1.00)
	await tween.finished
	music_player.stop()
	music_player.stream = music
	music_player.pitch_scale = pitch_scale
	music_player.volume_db = volume_db
	music_player.play()
	var fade_in_tween = get_tree().create_tween()
	fade_in_tween.tween_property(music_player, "volume_db", -5, 1.00)
	await tween.finished


func play_sound(sound: AudioStream, volume_db: float = 0) -> void:
	for player in sound_players:
		if not player.playing:
			player.stream = sound
			player.volume_db = volume_db
			player.play()
			break

func stop_sounds()->void:
	for player in sound_players:
		player.stop()
