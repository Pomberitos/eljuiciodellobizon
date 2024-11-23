extends Control


func _ready() -> void:
	AudioManager.play_music(AudioManager.GAME_OVER_MUSIC)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Events.reset_singletons()
		get_tree().quit()

	if event.is_action_pressed("ui_accept"):
		Events.reset_singletons()
		get_tree().change_scene_to_file.bind("res://scenes/UIs/main_menu.tscn").call_deferred()
