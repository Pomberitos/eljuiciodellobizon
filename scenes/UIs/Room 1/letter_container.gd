extends Control

@export var letter_audio: AudioStreamPlayer


func _on_texture_rect_visibility_changed() -> void:
	if visible:
		letter_audio.play()
