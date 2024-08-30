extends Door

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and isPlayerNearby:
		if isDoorClosed:
			open()
		else:
			close()
		

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		isPlayerNearby = true


func _on_player_detector_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		isPlayerNearby = false
