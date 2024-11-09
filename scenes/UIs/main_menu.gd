extends Control

@export var audio_config_panel: Panel

func _ready():
	AudioManager.play_music(AudioManager.MENU_MUSIC)
	
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		audio_config_panel.visible = false

func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

func _on_configuracion_pressed():
	audio_config_panel.visible = true