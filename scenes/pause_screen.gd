extends Control



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_paused()
		
func toggle_paused() -> void:
	if get_tree().paused:
		self.hide()
		get_tree().paused = false
		
	elif !get_tree().paused:
		self.show()
		get_tree().paused = true