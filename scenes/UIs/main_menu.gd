extends Control


func _ready():
	AudioManager.play_music(AudioManager.MENU_MUSIC)

func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
