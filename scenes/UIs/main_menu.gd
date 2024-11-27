extends Control

@export var config_panel: CanvasLayer
@export var credits_panel: CanvasLayer
@export var audio_panel: Panel
@export var audio_rect: TextureRect
@export var control_panel: Panel
@export var control_rect: TextureRect
@export var animation_player: AnimationPlayer
@export var reset_config: Button


func _ready():
	get_tree().paused = false
	Dialogic.end_timeline()
	FadeTransition.transition_fade_in()
	AudioManager.play_music(AudioManager.MENU_MUSIC)
	
func _on_new_game_button_pressed():
	get_tree().change_scene_to_file.bind("res://scenes/main.tscn").call_deferred()


func _on_quit_button_pressed():
	get_tree().quit()

func _on_volver_button_pressed() -> void:
	config_panel.hide()
	
func _on_config_button_pressed() -> void:
	config_panel.show()


func _on_audio_pressed() -> void:
	control_panel.hide()
	control_rect.hide()
	audio_panel.show()
	audio_rect.show()
	reset_config.visible = audio_panel.visible
	
func _on_controles_pressed() -> void:
	audio_panel.hide()
	audio_rect.hide()
	control_panel.show()
	control_rect.show()
	reset_config.visible = audio_panel.visible

func _on_credits_button_pressed() -> void:
	credits_panel.show()


func _on_back_button_pressed() -> void:
	credits_panel.hide()


func _on_timer_timeout() -> void:
	animation_player.play("eyes")


func _on_reset_config_pressed() -> void:
	Events.sound_config_reset.emit()
