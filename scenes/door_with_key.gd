extends Door

signal door_opened

@export var interaction_area: InteractionArea
var player: Player = null


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	door_opened.connect(on_door_opened)


func _on_interact() -> void:
	player = interaction_area.current_player as Player
	emit_signal("door_opened")
	

func on_door_opened() -> void:
	if isDoorClosed:
		open()
	else:
		close()
 