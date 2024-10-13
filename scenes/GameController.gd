extends Node2D

func _ready() -> void:
	Events.letter_displayed.connect(_on_letter_displayed)
	Events.letter_removed.connect(_on_letter_removed)
	Events.slasher_spawned.connect(_on_slasher_spawned)
	Events.slasher_gone.connect(_on_slasher_gone)
	Events.object_picked.connect(_on_object_picked)
	Dialogic.timeline_started.connect(_on_dialogue_started)
	Dialogic.timeline_ended.connect(_on_dialogue_ended)
	AudioManager.play_music(AudioManager.GAME_MUSIC)


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

func _on_letter_removed():
	get_tree().paused = false
	AudioManager.play_music(AudioManager.GAME_MUSIC)

func _on_slasher_spawned(_room: Room):
	AudioManager.play_music(AudioManager.CHASING_MUSIC)

func _on_slasher_gone():
	AudioManager.play_music(AudioManager.GAME_MUSIC)

func _on_object_picked(_object: InventoryItem):
	get_tree().change_scene_to_file("res://scenes/UIs/finish_mvp.tscn")

func _on_dialogue_started():
	$Player.can_move = false

func _on_dialogue_ended():
	$Player.can_move = true