extends Node

var current_room: Room
signal room_entered(next_room)
signal slasher_spawned

func _ready() -> void:
	connect("room_entered", set_current_room)
	
func set_current_room(new_room: Room):
	current_room = new_room
	print("Current " + str(current_room.number))
