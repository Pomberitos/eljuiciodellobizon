extends Room

var hasShownMaiddialogue = false

func _ready():
	super()
	Events.room_entered.connect(_on_room_entered)

func _on_room_entered(room: Room) -> void:
	if room.name == "Dinner 1" and not hasShownMaiddialogue:
		hasShownMaiddialogue = true
		Dialogic.start("room-3-1")
