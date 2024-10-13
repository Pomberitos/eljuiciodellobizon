extends Room

var hasShownMaiddialogue = false

func _on_room_entered(room: Room) -> void:
	if room.name == "Room 3" and not hasShownMaiddialogue:
		hasShownMaiddialogue = true
		Dialogic.start("room-3-1")
