extends Room

func _ready() -> void:
	super()
	Events.room_entered.connect(_on_room_entered)

func _on_room_entered(room: Room) -> void:
	if room.name == "Attic":
			get_tree().change_scene_to_file.bind("res://scenes/UIs/game_finished.tscn").call_deferred()
