extends Node

func _ready() -> void:
	Events.letter_displayed.connect(_on_letter_displayed)
	Events.letter_removed.connect(_on_letter_removed)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://scenes/UIs/game_finished.tscn")

func _on_letter_display_letter(letter: PackedScene) -> void:
	add_child(letter.instance())

func _on_letter_displayed():
	get_tree().paused = true

func _on_letter_removed():
	get_tree().paused = false