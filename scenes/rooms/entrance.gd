extends Room

func _ready() -> void:
	super()
	Events.room_entered.connect(_on_room_entered)

func _on_room_entered(room: Room) -> void:
	if room.name == "Entrance":
		Dialogic.start("ricky-intro")
