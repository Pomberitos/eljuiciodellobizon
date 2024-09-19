extends Node

var current_room: Room
signal room_entered(next_room)
signal slasher_spawned
signal slasher_gone
signal letter_displayed
signal letter_removed
signal box_moved(move_dir:Vector2i)

func _ready() -> void:
	connect("room_entered", set_current_room)
	
func set_current_room(new_room: Room):
	current_room = new_room
