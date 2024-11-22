extends Room


func _ready():
	super()
	Events.room_entered.connect(_on_room_entered)

func _on_room_entered(room: Room) -> void:
	pass
