extends Room

func _ready() -> void:
	super()
	Events.cinematic_finished.connect(_on_cinematic_finished)

func _on_cinematic_finished() -> void:
	if Events.current_room.label_name == "Entrance":
		Dialogic.start("ricky-intro")
