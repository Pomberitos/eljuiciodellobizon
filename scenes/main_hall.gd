extends Room

@onready var first_dialogue_shown = false


func _ready():
	super()
	Events.room_entered.connect(_on_room_entered)

func _on_room_entered(room: Room) -> void:
	if room.name == "Main Hall" and not first_dialogue_shown:
		first_dialogue_shown = true
		Dialogic.start("main-room")
