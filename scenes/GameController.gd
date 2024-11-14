extends Node2D

# Ugly fix to use the cinematic music when initiating the game
var is_cinematic_showing: bool = true

func _ready() -> void:
	FadeTransition.transition_fade_in()
	Events.letter_displayed.connect(_on_letter_displayed)
	Events.letter_removed.connect(_on_letter_removed)
	Events.puzzle1_hint_displayed.connect(_on_hint_displayed)
	Events.puzzle1_hint_removed.connect(_on_letter_removed)
	Events.hamster_puzzle_displayed.connect(_on_hamster_puzzle_displayed)
	Events.hamster_puzzle_removed.connect(_on_hamsbter_puzzle_removed)
	Events.slasher_spawned.connect(_on_slasher_spawned)
	Events.slasher_gone.connect(_on_slasher_gone)
	Events.object_picked.connect(_on_object_picked)
	Events.cinematic_finished.connect(_on_cinematic_finished)
	AudioManager.play_music(AudioManager.CINEMATIC_MUSIC)


func _unhandled_input(_event: InputEvent) -> void:
	# Set the fullscreen toggle key to f11 because that's what it is on my keyboard
	if Input.is_action_pressed("ui_home"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	if Input.is_action_pressed("escape_full"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scenes/UIs/game_finished.tscn")


func _on_letter_display_letter(letter: PackedScene) -> void:
	add_child(letter.instance())


func _on_letter_displayed():
	AudioManager.play_music(AudioManager.LETTER_MUSIC)


func _on_hint_displayed():
	AudioManager.play_music(AudioManager.LETTER_MUSIC)


func _on_hamster_puzzle_displayed():
	AudioManager.play_music(AudioManager.LETTER_MUSIC)


func _on_hamsbter_puzzle_removed():
	print("hamster puzzle removed")
	AudioManager.play_music(AudioManager.GAME_MUSIC)


func _on_letter_removed():
	print("letter removed")
	get_tree().paused = false
	AudioManager.play_music(AudioManager.GAME_MUSIC)


func _on_slasher_spawned(_room: Room):
	AudioManager.play_music(AudioManager.CHASING_MUSIC)


func _on_slasher_gone():
	if is_cinematic_showing:
		return
	AudioManager.play_music(AudioManager.GAME_MUSIC)

func _on_cinematic_finished():
	AudioManager.play_music(AudioManager.GAME_MUSIC)
	is_cinematic_showing = false


func _on_object_picked(_object: InventoryItem):
	# get_tree().change_scene_to_file("res://scenes/UIs/finish_mvp.tscn")
	pass
