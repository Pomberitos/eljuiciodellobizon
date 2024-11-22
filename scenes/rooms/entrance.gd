extends Room
var first_dialogue_shown = false
func _ready() -> void:
	super()
	Events.cinematic_finished.connect(_on_cinematic_finished)

func _on_cinematic_finished() -> void:
	if Events.current_room.label_name == "Entrance" and not first_dialogue_shown:
		first_dialogue_shown = true
		Dialogic.start("ricky-intro")
