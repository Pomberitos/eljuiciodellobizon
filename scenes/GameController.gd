extends Node

func _ready() -> void:
	Events.letter_displayed.connect(_on_letter_displayed)
	Events.letter_removed.connect(_on_letter_removed)
	Events.slasher_spawned.connect(_on_slasher_spawned)
	Events.slasher_gone.connect(_on_slasher_gone)
	AudioManager.play_music(AudioManager.GAME_MUSIC)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scenes/UIs/game_finished.tscn")

func _on_letter_display_letter(letter: PackedScene) -> void:
	add_child(letter.instance())

func _on_letter_displayed():
	AudioManager.play_music(AudioManager.LETTER_MUSIC)

func _on_letter_removed():
	get_tree().paused = false
	AudioManager.play_music(AudioManager.GAME_MUSIC)

func _on_slasher_spawned(_room: Room):
	AudioManager.play_music(AudioManager.CHASING_MUSIC)

func _on_slasher_gone():
	AudioManager.play_music(AudioManager.GAME_MUSIC)