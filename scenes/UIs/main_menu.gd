extends Control

@export var config_panel: CanvasLayer
@export var credits_panel: CanvasLayer
@export var audio_panel: Panel
@export var control_panel: Panel

func _ready():
	FadeTransition.transition_fade_in()
	AudioManager.play_music(AudioManager.MENU_MUSIC)
	
func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_pressed():
	get_tree().quit()

func _on_volver_button_pressed() -> void:
	config_panel.hide()
	
func _on_config_button_pressed() -> void:
	config_panel.show()


func _on_audio_pressed() -> void:
	control_panel.hide()
	audio_panel.show()
	
func _on_controles_pressed() -> void:
	audio_panel.hide()
	control_panel.show()

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		config_panel.hide()


func _on_credits_button_pressed() -> void:
	credits_panel.show()


func _on_back_button_pressed() -> void:
	credits_panel.hide()
