extends Camera2D


func _ready() -> void:
	Events.room_entered.connect(go_to_room)


func go_to_room(room):
	global_position = room.global_position
